require 'formula'

class OpenmpRt < Formula
  url "https://www.openmprtl.org/sites/default/files/libomp_20131209_oss.tgz"
  sha1 "8a2bb24372dcddd275f374bcddfc0c5103cb0147"
  homepage 'https://www.openmprtl.org'

  def install
    args = [
        "compiler=#{ENV.compiler}",
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
