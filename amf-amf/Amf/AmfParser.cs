// AmfParser.cs
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
using System.Collections.Generic;
using System.IO;
using System.Text;

namespace Amf
{
    public class AmfParser
    {
        public static readonly object EndOfObjectMarker = new object();

        private static readonly Mono.DataConverter conv = Mono.DataConverter.BigEndian;

        private Stream stream;

        // AMF3 data actually shares context like object references, so we
        // must keep the state around here.
        private Amf3Parser amf3Parser;

        public bool PreserveAmf3Context { get; set; }

        public AmfParser(Stream stream)
        {
            PreserveAmf3Context = true;

            if (stream == null)
                throw new ArgumentNullException("stream");

            this.stream = stream;
        }

        public object ReadNextObject()
        {
            int b = stream.ReadByte();
            if (b < 0)
                throw new EndOfStreamException();

            AmfTypeCode code = (AmfTypeCode) b;

            switch (code) {
            case AmfTypeCode.Number:
                return ReadNumber();

            case AmfTypeCode.Boolean:
                return ReadBoolean();

            case AmfTypeCode.String:
                return ReadString();

            case AmfTypeCode.Object:
                return ReadObject();

            case AmfTypeCode.Null:
                return null;

            case AmfTypeCode.Undefined:
                return null;

            case AmfTypeCode.EndOfObject:
                return EndOfObjectMarker;

            case AmfTypeCode.Array:
                return ReadArray();

            case AmfTypeCode.Date:
                return ReadDate();

            case AmfTypeCode.LongString:
            case AmfTypeCode.Xml:
                return ReadLongString();

            case AmfTypeCode.TypedObject:
                return ReadTypedObject();

            case AmfTypeCode.Amf3Data:
                if (amf3Parser == null || !PreserveAmf3Context)
                    amf3Parser = new Amf3Parser(stream);

                Amf3Wrapper wrapper = new Amf3Wrapper(amf3Parser.ReadNextObject());

                if (!PreserveAmf3Context)
                    amf3Parser = null;

                return wrapper;
            }

            throw new InvalidOperationException("Cannot parse type " + code);
        }

        public double ReadNumber()
        {
            return conv.GetDouble(stream.Read(8), 0);
        }

        public bool ReadBoolean()
        {
            int b = stream.ReadByte();
            if (b < 0)
                throw new EndOfStreamException();

            return b != 0;
        }

        internal short ReadInt16()
        {
            return conv.GetInt16(stream.Read(2), 0);
        }

        internal int ReadInt32()
        {
            return conv.GetInt32(stream.Read(4), 0);
        }

        public string ReadString()
        {
            short len = ReadInt16();
            byte[] str = stream.Read(len);

            return Encoding.UTF8.GetString(str);
        }

        private void ReadPropertiesInto(IDictionary<string, object> dict)
        {
            string key = ReadString();
            object obj = ReadNextObject();

            while (obj != EndOfObjectMarker) {
                dict[key] = obj;

                key = ReadString();
                obj = ReadNextObject();
            }
        }

        public AmfObject ReadObject()
        {
            AmfObject obj = new AmfObject();

            ReadPropertiesInto(obj.Properties);

            return obj;
        }

        public object[] ReadArray()
        {
            int len = ReadInt32();
            object[] arr = new object[len];

            for (int i = 0; i < len; i++) {
                arr[i] = ReadNextObject();
            }

            return arr;
        }

        public DateTime ReadDate()
        {
            double ms = ReadNumber();
            short offset = ReadInt16();

            // GMT offset is in minutes.  Convert ms to GMT for simplicity.
            ms += offset * 60 * 1000;

            // Convert ms to 100-nanosecond units (1000000 / 100) for DateTime constructor.
            ms *= 10000;

            return new DateTime((long)ms, DateTimeKind.Utc);
        }

        public string ReadLongString()
        {
            int len = ReadInt32();
            byte[] str = stream.Read(len);

            return Encoding.UTF8.GetString(str);
        }

        public AmfObject ReadTypedObject()
        {
            string className = ReadString();
            AmfObject obj = new AmfObject(className);

            ReadPropertiesInto(obj.Properties);

            return obj;
        }
    }
}
