// AmfWriter.cs
//
// Copyright (c) 2009 Chris Howie
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Text;

namespace Amf
{
    public class AmfWriter
    {
        private static readonly Mono.DataConverter conv = Mono.DataConverter.BigEndian;

        public Stream Stream { get; private set; }

        // AMF3 data actually shares context like object references, so we
        // must keep the state around here.
        private Amf3Writer amf3Writer;

        public AmfWriter(Stream stream)
        {
            if (stream == null)
                throw new ArgumentNullException("stream");

            Stream = stream;
            amf3Writer = new Amf3Writer(stream);
        }

        internal void WriteInt16(short int16)
        {
            Stream.Write(conv.GetBytes(int16));
        }

        internal void WriteInt32(int int32)
        {
            Stream.Write(conv.GetBytes(int32));
        }

        private void Write(AmfTypeCode code)
        {
            Stream.WriteByte((byte)code);
        }

        public void Write(object obj)
        {
            if (obj == null) {
                Write(AmfTypeCode.Null);
                return;
            }

            if (obj is IAmfSerializable) {
                ((IAmfSerializable)obj).Serialize(this);
                return;
            }

            if (obj is string) {
                Write((string)obj);
                return;
            }

            if (obj is AmfObject) {
                Write((AmfObject)obj);
                return;
            }

            if (obj is DateTime) {
                Write((DateTime)obj);
                return;
            }

            if (obj is IList) {
                Write((IList)obj);
                return;
            }

            if (obj is Amf3Wrapper) {
                Write(AmfTypeCode.Amf3Data);
                amf3Writer.Write(((Amf3Wrapper)obj).Content);
                return;
            }

            if (obj is Amf3Array ||
                    obj is Amf3Object) {
                Write(AmfTypeCode.Amf3Data);
                amf3Writer.Write(obj);
                return;
            }

            if (obj is bool) {
                Write((bool)obj);
                return;
            }

            if (obj is byte ||
                    obj is sbyte ||
                    obj is short ||
                    obj is ushort ||
                    obj is int ||
                    obj is uint ||
                    obj is long ||
                    obj is ulong ||
                    obj is float ||
                    obj is double) {
                Write(Convert.ToDouble(obj));
                return;
            }

            throw new ArgumentException("obj: Cannot serialize instance of type " + obj.GetType().FullName);
        }

        public void Write(double number)
        {
            Write(AmfTypeCode.Number);
            TypelessWrite(number);
        }

        public void Write(float number)
        {
            Write((double)number);
        }

        public void Write(byte number)
        {
            Write((double)number);
        }

        public void Write(sbyte number)
        {
            Write((double)number);
        }

        public void Write(short number)
        {
            Write((double)number);
        }

        public void Write(ushort number)
        {
            Write((double)number);
        }

        public void Write(int number)
        {
            Write((double)number);
        }

        public void Write(uint number)
        {
            Write((double)number);
        }

        public void Write(long number)
        {
            Write((double)number);
        }

        public void Write(ulong number)
        {
            Write((double)number);
        }

        public void Write(bool boolean)
        {
            Write(AmfTypeCode.Boolean);
            TypelessWrite(boolean);
        }

        public void Write(string str)
        {
            byte[] bytes = Encoding.UTF8.GetBytes(str);

            if (bytes.Length > ushort.MaxValue) {
                Write(AmfTypeCode.LongString);
                TypelessWrite((uint)bytes.Length);
            } else {
                Write(AmfTypeCode.String);
                TypelessWrite((ushort)bytes.Length);
            }

            Stream.Write(bytes);
        }

        public void Write(AmfObject obj)
        {
            Write(obj.ClassName != null ? AmfTypeCode.TypedObject : AmfTypeCode.Object);
            TypelessWrite(obj);
        }

        public void Write(IList list)
        {
            Write(AmfTypeCode.Array);
            TypelessWrite(list);
        }

        public void Write(DateTime date)
        {
            Write(AmfTypeCode.Date);
            TypelessWrite(date);
        }

        public void TypelessWrite(double number)
        {
            Stream.Write(conv.GetBytes(number));
        }

        public void TypelessWrite(float number)
        {
            TypelessWrite((double)number);
        }

        public void TypelessWrite(bool boolean)
        {
            Stream.WriteByte((byte)(boolean ? 1 : 0));
        }

        public void TypelessWrite(short int16)
        {
            Stream.Write(conv.GetBytes(int16));
        }

        public void TypelessWrite(ushort uint16)
        {
            Stream.Write(conv.GetBytes(uint16));
        }

        public void TypelessWrite(int int32)
        {
            Stream.Write(conv.GetBytes(int32));
        }

        public void TypelessWrite(uint uint32)
        {
            Stream.Write(conv.GetBytes(uint32));
        }

        public void TypelessWriteString(string str)
        {
            byte[] bytes = Encoding.UTF8.GetBytes(str);

            if (bytes.Length > ushort.MaxValue)
                throw new ArgumentException("str: String is too long to be serialized.");

            TypelessWrite((ushort)bytes.Length);
            Stream.Write(bytes);
        }

        public void TypelessWriteLongString(string str)
        {
            byte[] bytes = Encoding.UTF8.GetBytes(str);

            TypelessWrite(bytes.Length);
            Stream.Write(bytes);
        }

        private void WriteProperties(IDictionary<string, object> properties)
        {
            foreach (KeyValuePair<string, object> i in properties) {
                TypelessWriteString(i.Key);
                Write(i.Value);
            }

            TypelessWrite((ushort)0);
            Write(AmfTypeCode.EndOfObject);
        }

        public void TypelessWrite(AmfObject obj)
        {
            if (obj.ClassName != null)
                TypelessWriteString(obj.ClassName);

            WriteProperties(obj.Properties);
        }

        public void TypelessWrite(IList list)
        {
            TypelessWrite(list.Count);

            foreach (object i in list) {
                Write(i);
            }
        }

        public void TypelessWrite(DateTime date)
        {
            date = date.ToUniversalTime();

            // Convert the ticks from 100-nanosecond units to ms.
            double ms = ((double)date.Ticks) / 10000;

            TypelessWrite(ms);

            // The UTC offset, which is 0 since we convert to UTC.
            TypelessWrite((short)0);
        }
    }
}
