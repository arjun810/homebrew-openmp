require 'formula'

class OpenmpRt < Formula
  url "https://www.openmprtl.org/sites/default/files/libomp_20131209_oss.tgz"
  sha1 "8a2bb24372dcddd275f374bcddfc0c5103cb0147"
  homepage 'https://www.openmprtl.org'

  def install
    ENV.append "CFLAGS", "-Wno-error=unused-command-line-argument-hard-error-in-future"
    ENV.append "CXFLAGS", "-Wno-error=unused-command-line-argument-hard-error-in-future"
    
    args = [
        "compiler=#{ENV.compiler}", "Wno-error=unused-command-line-argument-hard-error-in-future"
    ]

    system "make", *args
    include.install Dir["tmp/*rel*/*.h"]
    include.install Dir["tmp/*rel*/*.f"]
    include.install Dir["tmp/*rel*/*.f90"]
    lib.install Dir["tmp/*rel*/*.dylib"]
  end

  def patches
    if MacOS.version >= :mavericks && ENV.compiler == :clang
        DATA
    end
  end

end

__END__
diff --git a/tools/check-tools.pl b/tools/check-tools.pl
index 4001469..699e54d 100755
--- a/tools/check-tools.pl
+++ b/tools/check-tools.pl
@@ -447,12 +447,8 @@ if ( $intel ) {
 }; # if
 if ( $target_os eq "lin" or $target_os eq "mac" ) {
     # check for gnu tools by default because touch-test.c is compiled with them.
-    push( @versions, [ "GNU C Compiler",     get_gnu_compiler_version( $gnu_compilers->{ $target_os }->{ c   } ) ] );
-    push( @versions, [ "GNU C++ Compiler",   get_gnu_compiler_version( $gnu_compilers->{ $target_os }->{ cpp } ) ] );
-    if ( $clang ) {
-        push( @versions, [ "Clang C Compiler",     get_clang_compiler_version( $clang_compilers->{ $target_os }->{ c   } ) ] );
-        push( @versions, [ "Clang C++ Compiler",   get_clang_compiler_version( $clang_compilers->{ $target_os }->{ cpp } ) ] );
-    }; 
+    push( @versions, [ "Clang C Compiler",     get_clang_compiler_version( $clang_compilers->{ $target_os }->{ c   } ) ] );
+    push( @versions, [ "Clang C++ Compiler",   get_clang_compiler_version( $clang_compilers->{ $target_os }->{ cpp } ) ] );
     # if intel fortran has been checked then gnu fortran is unnecessary
     # also, if user specifies clang as build compiler, then gfortran is assumed fortran compiler
     if ( $fortran and not $intel ) {
diff --git a/src/makefile.mk b/src/makefile.mk
index dfebc10..621bb38 100644
--- a/src/makefile.mk
+++ b/src/makefile.mk
@@ -411,7 +411,6 @@ ifeq "$(os)" "lrb"
     ld-flags += -Wl,--version-script=$(src_dir)exports_so.txt
     ld-flags += -static-intel
     # Don't link libcilk*.
-    ld-flags += -no-intel-extensions
     # Discard unneeded dependencies.
     ld-flags += -Wl,--as-needed
 #    ld-flags += -nodefaultlibs
@@ -430,7 +429,6 @@ ifeq "$(os)" "lrb"
 endif
 
 ifeq "$(os)" "mac"
-    ld-flags += -no-intel-extensions
     ld-flags += -single_module
     ld-flags += -current_version $(VERSION).0 -compatibility_version $(VERSION).0
 endif
@@ -1118,7 +1116,7 @@ ifeq "$(mac_os_new)" "1"
 else
     iomp$(obj) : $(lib_obj_files) external-symbols.lst external-objects.lst .rebuild
 	    $(target)
-	    $(c) -r -nostartfiles -static-intel  -no-intel-extensions \
+	    $(c) -r -nostartfiles -static-intel   \
 		-Wl,-unexported_symbols_list,external-symbols.lst \
 		-Wl,-non_global_symbols_strip_list,external-symbols.lst \
 		-filelist external-objects.lst \
