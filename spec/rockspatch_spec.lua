local patch = require("rocks.patch")
local fs = require("rocks.fs")
local sysdetect = require("rocks.sysdetect")

local lao =
[[The Nameless is the origin of Heaven and Earth;
The named is the mother of all things.

Therefore let there always be non-being,
  so we may see their subtlety,
And let there always be being,
  so we may see their outcome.
The two are the same,
But after they are produced,
  they have different names.
They both may be called deep and profound.
Deeper and more profound,
The door of all subtleties!]]

local tzu =
[[The Way that can be told of is not the eternal Way;
The name that can be named is not the eternal name.
The Nameless is the origin of Heaven and Earth;
The Named is the mother of all things.
Therefore let there always be non-being,
  so we may see their subtlety,
And let there always be being,
  so we may see their outcome.
The two are the same,
But after they are produced,
  they have different names.]]

local valid_patch1 =
[[--- lao	2002-02-21 23:30:39.942229878 -0800
+++ tzu	2002-02-21 23:30:50.442260588 -0800
@@ -1,7 +1,6 @@
-The Way that can be told of is not the eternal Way;
-The name that can be named is not the eternal name.
 The Nameless is the origin of Heaven and Earth;
-The Named is the mother of all things.
+The named is the mother of all things.
+
 Therefore let there always be non-being,
   so we may see their subtlety,
 And let there always be being,
@@ -9,3 +8,6 @@
 The two are the same,
 But after they are produced,
   they have different names.
+They both may be called deep and profound.
+Deeper and more profound,
+The door of all subtleties!]]

local valid_patch2 =
[[--- /dev/null	1969-02-21 23:30:39.942229878 -0800
+++ tzu	2002-02-21 23:30:50.442260588 -0800
@@ -1,7 +1,6 @@
-The Way that can be told of is not the eternal Way;
-The name that can be named is not the eternal name.
 The Nameless is the origin of Heaven and Earth;
-The Named is the mother of all things.
+The named is the mother of all things.
+
 Therefore let there always be non-being,
   so we may see their subtlety,
 And let there always be being,
@@ -9,3 +8,6 @@
 The two are the same,
 But after they are produced,
   they have different names.
+They both may be called deep and profound.
+Deeper and more profound,
+The door of all subtleties!]]

local invalid_patch1 =
[[--- lao	2002-02-21 23:30:39.942229878 -0800
+++ tzu	2002-02-21 23:30:50.442260588 -0800
@@ -1,7 +1,6 @@
-The Way that can be told of is not the eternal Way;
-The name that can be named is not the eternal name.
 The Nameless is the origin of Heaven and Earth;
-The Named is the mother of all things.
--- Extra
+The named is the mother of all things.
+
 Therefore let there always be non-being,
   so we may see their subtlety,
 And let there always be being,
--- Extra
@@ -9,3 +8,7 @@
 The two are the same,
 But after they are produced,
   they have different names.
+They both may be called deep and profound.
+Deeper and more profound,
+The door of all subtleties!]]

local invalid_patch2 =
[[--- lao	2002-02-21 23:30:39.942229878 -0800
+++   tzu	2002-02-21 23:30:50.442260588 -0800
@@ -1,7 +1,6 @@
-The Way that can be told of is not the eternal Way;
-The name that can be named is not the eternal name.
 The Nameless is the origin of Heaven and Earth;
-The Named is the mother of all things.
+The named is the mother of all things.
+
 Therefore let there always be non-being,
   so we may see their subtlety,
 And let there always be being,
@@ -9,3 +8,6 @@
 The two are the same,
 But after they are produced,
   they have different names.
+They both may be called deep and profound.
+Deeper and more profound,
? ...
+The door of all subtleties!]]

local invalid_patch3 =
[[---     lao	2002-02-21 23:30:39.942229878 -0800
+++ tzu	2002-02-21 23:30:50.442260588 -0800
@@ -1,7 +1,6 @@
-The Way that can be told of is not the eternal Way;
-The name that can be named is not the eternal name.
 The Nameless is the origin of Heaven and Earth;
-The Named is the mother of all things.
+The named is the mother of all things.
+
 Therefore let there always be non-being,
   so we may see their subtlety,
 And let there always be being,
@@ -9,3 +8,6 @@
 The two are the same,
 But after they are produced,
   they have different names.
+They both may be called deep and profound.
+Deeper and more profound,
? ...
+The door of all subtleties!]]

describe("Luarocks patch test #unit", function()

   --- Create a file containing a string.
   -- @param pathname string: path to file.
   -- @param str string: content of the file.
   local write_file = function (pathname, str, finally)
         local file = assert(io.open(pathname, "w"))
         file:write(str)
         file:close()
         if finally then
            finally(function()
               os.remove(pathname)
            end)
         end
   end

   local function get_tmp_path()
      local path = os.tmpname()
      if package.config:sub(1,1) == "\\" and not path:find(":") then
         path = os.getenv("TEMP") .. path
      end
      os.remove(path)
      return path
   end

   local platform_sets = {
      freebsd = { unix = true, bsd = true, freebsd = true },
      openbsd = { unix = true, bsd = true, openbsd = true },
      solaris = { unix = true, solaris = true },
      windows = { windows = true, win32 = true },
      cygwin = { unix = true, cygwin = true },
      macosx = { unix = true, bsd = true, macosx = true, macos = true },
      netbsd = { unix = true, bsd = true, netbsd = true },
      haiku = { unix = true, haiku = true },
      linux = { unix = true, linux = true },
      mingw = { windows = true, win32 = true, mingw32 = true, mingw = true },
      msys = { unix = true, cygwin = true, msys = true },
      msys2_mingw_w64 = { windows = true, win32 = true, mingw32 = true, mingw = true, msys = true, msys2_mingw_w64 = true },
   }
   
   setup(function ()
      local plats = {}
      local sys, _ = sysdetect.detect()
      if platform_sets[sys] then
         for platforms, _ in pairs(platform_sets[sys]) do
               plats[#plats+1] = platforms
         end
      end
       
      fs.init(plats)
   end)
   
   describe("patch.read_patch", function()
      it("returns a table with the patch file info and the result of parsing the file", function()
         local t, result

         write_file("test.patch", valid_patch1, finally)
         t, result = patch.read_patch("test.patch")
         assert.truthy(result)
         assert.truthy(t)

         write_file("test.patch", invalid_patch1, finally)
         t, result = patch.read_patch("test.patch")
         assert.falsy(result)
         assert.truthy(t)

         write_file("test.patch", invalid_patch2, finally)
         t, result = patch.read_patch("test.patch")
         assert.falsy(result)
         assert.truthy(t)

         write_file("test.patch", invalid_patch3, finally)
         t, result = patch.read_patch("test.patch")
         assert.falsy(result)
         assert.truthy(t)
      end)
   end)

   describe("patch.apply_patch", function()
      local tmpdir
      local olddir

      before_each(function()
         tmpdir = get_tmp_path()
         olddir = lfs.currentdir()
         lfs.mkdir(tmpdir)
         lfs.chdir(tmpdir)

         write_file("lao", tzu, finally)
         write_file("tzu", lao, finally)
      end)

      after_each(function()
         if olddir then
            lfs.chdir(olddir)
            if tmpdir then
               lfs.rmdir(tmpdir)
            end
         end
      end)

      it("applies the given patch and returns the result of patching", function()
         write_file("test.patch", valid_patch1, finally)
         local p = patch.read_patch("test.patch")
         local result = patch.apply_patch(p)
         assert.truthy(result)
      end)

      it("applies the given patch with custom arguments and returns the result of patching", function()
         write_file("test.patch", valid_patch2, finally)
         local p = patch.read_patch("test.patch")
         local result = patch.apply_patch(p, nil, true)
         assert.truthy(result)
      end)

      it("fails if the patch file is invalid", function()
         write_file("test.patch", invalid_patch1, finally)
         local p = patch.read_patch("test.patch")
         local result = pcall(patch.apply_patch, p)
         assert.falsy(result)
      end)

      it("returns false if the files from the patch doesn't exist", function()
         os.remove("lao")
         os.remove("tzu")

         write_file("test.patch", valid_patch1, finally)
         local p = patch.read_patch("test.patch")
         local result = patch.apply_patch(p)
         assert.falsy(result)
      end)

      it("returns false if the target file was already patched", function()
         write_file("test.patch", valid_patch1, finally)
         local p = patch.read_patch("test.patch")
         local result = patch.apply_patch(p)
         assert.truthy(result)

         result = patch.apply_patch(p)
         assert.falsy(result)
      end)
   end)
end)
