// AmfHeader.cs
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

namespace Amf
{
    public class AmfHeader : IAmfSerializable
    {
        public string Name { get; set; }

        public bool Required { get; set; }

        public object Value { get; set; }

        private AmfHeader() {}

        public AmfHeader(string name, object value)
        {
            Name = name;
            Value = value;
        }

        public static AmfHeader Read(AmfParser parser)
        {
            AmfHeader header = new AmfHeader();

            header.Name = parser.ReadString();
            header.Required = parser.ReadBoolean();

            int hlen = parser.ReadInt32();

            header.Value = parser.ReadNextObject();

            return header;
        }

        void IAmfSerializable.Serialize(AmfWriter writer)
        {
            writer.TypelessWriteString(Name);
            writer.TypelessWrite(Required);

            MemoryStream stream = new MemoryStream();
            new AmfWriter(stream).Write(Value);

            byte[] data = stream.ToArray();

            writer.WriteInt32(data.Length);
            writer.Stream.Write(data);
        }
    }
}
