require 'formula'

class LlvmOmp < Formula
  head "https://github.com/clang-omp/llvm.git"
  homepage 'http://clang-omp.github.io/'

  resource "compiler-rt" do
    url "https://github.com/clang-omp/compiler-rt.git"
  end

  resource "clang-omp" do
    url 'https://github.com/clang-omp/clang.git', :branch => 'clang-omp'
  end

  def add_suffix(filename, suffix)
      dir = File.dirname(filename)
      ext = File.extname(filename)
      base = File.basename(filename, ext)
      File.rename filename, "#{dir}/#{base}-#{suffix}#{ext}"
  end

  def install

    version_suffix = "omp"

    (buildpath/'projects/compiler-rt').install resource('compiler-rt')
    (buildpath/'tools/clang').install resource('clang-omp')

    mkdir "build"
    cd "build"

    args = [
        "--prefix=#{prefix}",
        "--enable-libcpp",
        "--enable-cxx11",
        "--enable-optimized",
    ]

    # Will eventually want this in args when it's implemented.
    # "--program-suffix=#{version_suffix}"

    system "../configure", *args
    system "make"

    cd "tools/clang"
    system "make install"

    # clang ignores "--program-suffix" so we have to do it manually
    Dir.glob(bin/"*") { |f| add_suffix f, version_suffix }

    # Rename man1
    Dir.glob(man1/"*.1") { |f| add_suffix f, version_suffix }
  end

end
