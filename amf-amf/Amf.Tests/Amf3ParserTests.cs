// Amf3ParserTests.cs
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
    public class Amf3ParserTests
    {
        private static void TestGetInteger(int num, byte[] enc)
        {
            Assert.AreEqual(num, new Amf3Parser(new MemoryStream(enc)).ReadInteger());
        }

        [Test]
        public void ReadIntegerMultibyte()
        {
            TestGetInteger(138, new byte[] { 0x81, 0x0a });
        }

        [Test]
        public void ReadIntegerNegative()
        {
            TestGetInteger(-1, new byte[] { 0xff, 0xff, 0xff, 0xff });
            TestGetInteger(int.MinValue >> 3, new byte[] { 0xc0, 0x80, 0x80, 0x00 });
        }
    }
}
