// Amf3WriterTests.cs
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

using Amf;
using NUnit.Framework;

namespace Amf.Tests
{
    [TestFixture]
    public class Amf3WriterTests
    {
        private void TestInt32(byte[] expected, int number)
        {
            MemoryStream stream = new MemoryStream();
            Amf3Writer writer = new Amf3Writer(stream);

            writer.TypelessWrite(number);

            CollectionAssert.AreEqual(expected, stream.ToArray());
        }

        [Test]
        public void WriteInt32Zero()
        {
            TestInt32(new byte[] { 0 }, 0);
        }

        [Test]
        public void WriteInt32NegativeOne()
        {
            TestInt32(new byte[] { 0xff, 0xff, 0xff, 0xff }, -1);
        }

        [Test]
        public void WriteInt32OneByte()
        {
            TestInt32(new byte[] { 0x42 }, 0x42);
        }

        [Test]
        public void WriteInt32TwoBytes()
        {
            TestInt32(new byte[] { 0xcb, 0x4a }, 0x25ca);
        }

        [Test]
        public void WriteInt32ThreeBytes()
        {
            TestInt32(new byte[] { 0xea, 0xa7, 0x38 }, 0x1a93b8);
        }

        [Test]
        public void WriteInt32ThreeBytesWithGap()
        {
            TestInt32(new byte[] { 0xc8, 0x80, 0x00 }, 0x120000);
        }

        [Test]
        public void WriteInt32FourBytes()
        {
            TestInt32(new byte[] { 0x9a, 0xbb, 0x9c, 0x34 }, 0x069d9c34);
        }
    }
}
