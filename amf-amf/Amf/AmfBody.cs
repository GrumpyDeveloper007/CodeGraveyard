// AmfBody.cs
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
using System.IO;

namespace Amf
{
    public class AmfBody : IAmfSerializable
    {
        public string Target { get; set; }

        public string Response { get; set; }

        public object Content { get; set; }

        public AmfBody() {}

        public static AmfBody Read(AmfParser parser)
        {
            AmfBody body = new AmfBody();

            body.Target = parser.ReadString();
            body.Response = parser.ReadString();

            int blen = parser.ReadInt32();

            body.Content = parser.ReadNextObject();

            return body;
        }

        void IAmfSerializable.Serialize(AmfWriter writer)
        {
            writer.TypelessWriteString(Target);
            writer.TypelessWriteString(Response);

            MemoryStream stream = new MemoryStream();
            new AmfWriter(stream).Write(Content);

            byte[] data = stream.ToArray();

            writer.WriteInt32(data.Length);
            writer.Stream.Write(data);
        }
    }
}
