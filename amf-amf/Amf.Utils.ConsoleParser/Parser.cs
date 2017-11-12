// Parser.cs
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
using System.Linq;
using System.Reflection;
using System.Text;
using System.Xml;
using System.Xml.Linq;

using Amf;
using Amf.XmlVisualizer;

namespace Amf.Utils.ConsoleParser
{
    public static class Parser
    {
        private delegate object ObjectReader(AmfParser parser);

        private static Type FindType(string type)
        {
            return (from i in AppDomain.CurrentDomain.GetAssemblies()
                    select i.GetType(type)).First(i => i != null);
        }

        private static ObjectReader GetTypeReader(string typeName)
        {
            Type type = FindType(typeName);

            MethodInfo info = type.GetMethod("Read", BindingFlags.Static | BindingFlags.Public,
                                             null, new Type[] { typeof(AmfParser) }, null);

            if (info == null)
                throw new ArgumentException("type: Specified type does not have a suitable static Read method.");

            return (ObjectReader)Delegate.CreateDelegate(typeof(ObjectReader), info);
        }

        private static object DefaultReader(AmfParser parser)
        {
            return parser.ReadNextObject();
        }

        public static void Main(string[] args)
        {
            FileStream str = File.OpenRead(args[0]);
            AmfParser parser = new AmfParser(str);

            ObjectReader reader;
            if (args.Length > 1) {
                reader = GetTypeReader(args[1]);
            } else {
                reader = DefaultReader;
            }

            object root;
            try {
                root = reader(parser);
            } catch (Exception) {
                Console.WriteLine("Exception at file location {0}", str.Position);
                throw;
            }

            Console.WriteLine("Parsing completed.  At position {0}/{1}.", str.Position, str.Length);
            Console.WriteLine();

            using (XmlTextWriter w = new XmlTextWriter(Console.Out)) {
                w.Formatting = Formatting.Indented;

                Visualizer.Visualize(root).WriteTo(w);
            }
        }
    }
}
