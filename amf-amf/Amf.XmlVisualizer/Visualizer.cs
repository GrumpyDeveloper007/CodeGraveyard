// Visualizer.cs
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

namespace Amf.XmlVisualizer
{
    public static class Visualizer
    {
        public static XNode Visualize(object obj)
        {
            return ObjectVisualizer(obj, null);
        }

        private class VisualizerDef
        {
            public readonly Func<object, XElement, XNode> Visualizer;
            public readonly Type Type;

            public VisualizerDef(Func<object, XElement, XNode> converter, Type type) {
                Visualizer = converter;
                Type = type;
            }
        }

        private static List<VisualizerDef> converters;

        static Visualizer()
        {
            converters = new List<VisualizerDef>();

            converters.Add(new VisualizerDef(Amf3ArrayVisualizer, typeof(Amf3Array)));
            converters.Add(new VisualizerDef(AmfBodyVisualizer, typeof(AmfBody)));
            converters.Add(new VisualizerDef(AmfHeaderVisualizer, typeof(AmfHeader)));
            converters.Add(new VisualizerDef(AmfObjectVisualizer, typeof(AmfObject)));
            converters.Add(new VisualizerDef(Amf3ObjectVisualizer, typeof(Amf3Object)));
            converters.Add(new VisualizerDef(AmfRequestVisualizer, typeof(AmfRequest)));
            converters.Add(new VisualizerDef(Amf3WrapperVisualizer, typeof(Amf3Wrapper)));
            converters.Add(new VisualizerDef(ListVisualizer, typeof(IList)));
            converters.Add(new VisualizerDef(DictionaryVisualizer, typeof(IDictionary)));
        }

        private static string GetPrettyTypeName(this Type type)
        {
            StringBuilder sb = new StringBuilder();

            if (type.Namespace != "") {
                sb.Append(type.Namespace);
                sb.Append('.');
            }
            sb.Append(type.Name);

            if (type.IsGenericType) {
                sb.Append('[');

                bool first = true;
                foreach (Type i in type.GetGenericArguments()) {
                    if (!first)
                        sb.Append(", ");

                    first = false;
                    sb.Append(i.GetPrettyTypeName());
                }

                sb.Append(']');
            }

            return sb.ToString();
        }

        private static XNode ObjectVisualizer(object o, XElement surrogate)
        {
            if (o == null)
                return new XElement("Null");

            Type type = o.GetType();

            foreach (VisualizerDef i in converters) {
                if (i.Type.IsAssignableFrom(type))
                    return i.Visualizer(o, surrogate);
            }

            if (surrogate != null) {
                surrogate.SetAttributeValue("Type", type.GetPrettyTypeName());
                return new XText(o.ToString());
            }

            return new XElement("ClrObject",
                new XAttribute("Type", type.GetPrettyTypeName()),
                o.ToString());
        }

        private static XElement ListItem(object o) {
            XElement item = new XElement("Item");
            item.Add(ObjectVisualizer(o, item));

            return item;
        }

        private static XNode ListVisualizer(object o, XElement surrogate)
        {
            IList list = (IList)o;

            var items = from i in list.Cast<object>() select ListItem(i);

            XAttribute typeAttr = new XAttribute("Type", o.GetType().GetPrettyTypeName());

            if (surrogate != null) {
                surrogate.Add(typeAttr, items);
                return null;
            }

            return new XElement("IList", typeAttr, items);
        }

        private static IEnumerable<DictionaryEntry> Entries(this IDictionary dict)
        {
            foreach (DictionaryEntry i in dict)
                yield return i;
        }

        private static XElement DictionaryItem(string key, object o) {
            XElement kvp = new XElement("KeyValuePair",
                new XAttribute("Key", key));
            kvp.Add(ObjectVisualizer(o, kvp));

            return kvp;
        }

        private static XNode DictionaryVisualizer(object o, XElement surrogate)
        {
            IDictionary dict = (IDictionary)o;

            var items = from i in dict.Entries() select DictionaryItem(i.Key.ToString(), i.Value);

            XAttribute typeAttr = new XAttribute("Type", o.GetType().GetPrettyTypeName());

            if (surrogate != null) {
                surrogate.Add(typeAttr, items);
                return null;
            }

            return new XElement("IDictionary", typeAttr, items);
        }

        private static XNode Amf3ArrayVisualizer(object o, XElement surrogate)
        {
            Amf3Array arr = (Amf3Array)o;

            XElement dense = null;
            XElement assoc = null;

            if (arr.DenseArray.Count > 0) {
                dense = new XElement("DenseArray");
                ListVisualizer(arr.DenseArray, dense);
            }

            if (arr.AssociativeArray.Count > 0) {
                assoc = new XElement("AssociativeArray");
                DictionaryVisualizer(arr.AssociativeArray, assoc);
            }

            return new XElement("Amf3Array", dense, assoc);
        }

        private static XNode AmfBodyVisualizer(object o, XElement surrogate)
        {
            AmfBody body = (AmfBody)o;

            return new XElement("AmfBody",
                new XAttribute("Target", body.Target),
                new XAttribute("Response", body.Response),
                ObjectVisualizer(body.Content, null)
            );
        }

        private static XNode AmfHeaderVisualizer(object o, XElement surrogate)
        {
            AmfHeader header = (AmfHeader)o;

            XElement xml = new XElement("AmfHeader");
            xml.Add(
                new XAttribute("Name", header.Name),
                new XAttribute("Required", header.Required.ToString()),
                ObjectVisualizer(header.Value, xml)
            );

            return xml;
        }

        private static XNode AmfObjectVisualizer(object o, XElement surrogate)
        {
            AmfObject obj = (AmfObject)o;

            XElement xml = new XElement("AmfObject");
            if (obj.ClassName != null)
                xml.SetAttributeValue("Class", obj.ClassName);

            DictionaryVisualizer(obj.Properties, xml);
            return xml;
        }

        private static XNode Amf3ObjectVisualizer(object o, XElement surrogate)
        {
            Amf3Object obj = (Amf3Object)o;

            XElement xml = new XElement("Amf3Object");

            if (!string.IsNullOrEmpty(obj.ClassDef.Name))
                xml.SetAttributeValue("Class", obj.ClassDef.Name);

            DictionaryVisualizer(obj.Properties, xml);
            return xml;
        }

        private static XNode AmfRequestVisualizer(object o, XElement surrogate)
        {
            AmfRequest request = (AmfRequest)o;

            return new XElement("AmfRequest",
                from i in request.Headers select AmfHeaderVisualizer(i, null),
                from i in request.Bodies select AmfBodyVisualizer(i, null)
            );
        }

        private static XNode Amf3WrapperVisualizer(object o, XElement surrogate)
        {
            Amf3Wrapper w = (Amf3Wrapper)o;

            if (surrogate != null) {
                surrogate.SetAttributeValue("Amf3Wrapped", "true");
                surrogate.Add(ObjectVisualizer(w.Content, surrogate));
                return null;
            } else {
                XElement element = new XElement("Amf3Wrapper");
                element.Add(ObjectVisualizer(w.Content, element));
                return element;
            }
        }
    }
}
