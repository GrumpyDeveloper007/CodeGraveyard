// Resolver.cs
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

namespace Amf
{
    public static class Resolver
    {
        public static bool TryResolve(object root, out object result, params string[] path)
        {
            try {
                result = Resolve(root, path);
                return true;
            } catch {
                result = null;
                return false;
            }
        }

        public static object Resolve(object root, params string[] path)
        {
            foreach (string i in path) {
                root = Resolve(root, i);
            }

            return root;
        }

        private static object Resolve(object root, string path)
        {
            while (root is Amf3Wrapper) {
                root = ((Amf3Wrapper)root).Content;
            }

            if (root == null)
                throw new ArgumentException("path: Path does not exist.");

            if (root is Amf3Array)
                return Resolve((Amf3Array)root, path);

            if (root is Amf3Object)
                return Resolve((Amf3Object)root, path);

            if (root is AmfObject)
                return Resolve((AmfObject)root, path);

            if (root is IList)
                return Resolve((IList)root, path);

            if (root is IDictionary)
                return Resolve((IDictionary)root, path);

            throw new ArgumentException("root: Cannot resolve from type " + root.GetType().FullName);
        }

        private static object Resolve(Amf3Array root, string path)
        {
            int intKey;
            if (int.TryParse(path, out intKey)) {
                return root.DenseArray[intKey];
            }

            object val;
            return root.AssociativeArray.TryGetValue(path, out val) ? val : null;
        }

        private static object Resolve(Amf3Object root, string path)
        {
            return root[path];
        }

        private static object Resolve(AmfObject root, string path)
        {
            return root[path];
        }

        private static object Resolve(IList root, string path)
        {
            int intKey;
            if (int.TryParse(path, out intKey)) {
                return root[intKey];
            }

            return null;
        }

        private static object Resolve(IDictionary root, string path)
        {
            return root[path];
        }
    }
}
