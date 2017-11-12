// AmfRequest.cs
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
    public class AmfRequest : IAmfSerializable
    {
        private List<AmfHeader> headers;

        public IList<AmfHeader> Headers {
            get { return headers; }
        }

        private List<AmfBody> bodies;

        public IList<AmfBody> Bodies {
            get { return bodies; }
        }

        public AmfRequest()
        {
            headers = new List<AmfHeader>();
            bodies = new List<AmfBody>();
        }

        public static AmfRequest Read(AmfParser parser)
        {
            AmfRequest req = new AmfRequest();

            short player = parser.ReadInt16();
            short headers = parser.ReadInt16();

            req.headers.AddRange(ReadHeaders(parser, headers));

            short bodies = parser.ReadInt16();

            req.bodies.AddRange(ReadBodies(parser, bodies));

            return req;
        }

        private static IEnumerable<AmfHeader> ReadHeaders(AmfParser parser, int count)
        {
            while (--count >= 0)
                yield return AmfHeader.Read(parser);
        }

        private static IEnumerable<AmfBody> ReadBodies(AmfParser parser, int count)
        {
            while (--count >= 0)
                yield return AmfBody.Read(parser);
        }

        void IAmfSerializable.Serialize(AmfWriter writer)
        {
            // 3 means Flash Player 9
            writer.WriteInt16(3);

            writer.WriteInt16(checked((short)Headers.Count));
            foreach (AmfHeader i in Headers) {
                writer.Write(i);
            }

            writer.WriteInt16(checked((short)Bodies.Count));
            foreach (AmfBody i in Bodies) {
                writer.Write(i);
            }
        }
    }
}
