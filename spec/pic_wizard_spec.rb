require_relative '../lib/pic_wizard'
require 'fileutils'

describe PicWizard do

  after(:each) do
    dirs = []
    dir1 = '/Users/rory/code/pic_wizard/test_dest/dir'
    dir2 = '/Users/rory/code/pic_wizard/test_dest/2018/November'
    dir3 = '/Users/rory/code/pic_wizard/test_dest/2018'
    dirs << dir1
    dirs << dir2
    dirs << dir3
    dirs.each do |dir|
      if (Dir.exists?(dir))
        FileUtils.rm_r(dir)
      end
    end
  end

  describe '.collect_file_names' do

    it 'can find HEIC files' do
      subject.collect_file_names
      expect(subject.files[0]).to eql('IMG_0603.HEIC')
    end

    it 'can find all relevant file types, excludes irrelevant file types' do
      expect(subject.files.include?('IMG_0603.HEIC')).to be false
      expect(subject.files.include?('IMG_0965.PNG')).to be false
      expect(subject.files.include?('IMG_0969.mov')).to be false
      expect(subject.files.include?('ScreenRecording.mp4')).to be false
      expect(subject.files.include?('camphoto_341603450 (2).jpg')).to be false
      subject.collect_file_names
      expect(subject.files.include?('IMG_0603.HEIC')).to be true
      expect(subject.files.include?('IMG_0965.PNG')).to be true
      expect(subject.files.include?('IMG_0969.mov')).to be true
      expect(subject.files.include?('ScreenRecording.mp4')).to be true
      expect(subject.files.include?('camphoto_341603450 (2).jpg')).to be true
      expect(subject.files.include?('no_copy.txt')).to be false
    end
  end

  describe '.create_directory' do

    it 'creates a test directory' do
      expect(Dir.exists?('/Users/rory/code/pic_wizard/test_dest/dir')).to be false
      subject.create_directory('/Users/rory/code/pic_wizard/test_dest/dir')
      expect(Dir.exists?('/Users/rory/code/pic_wizard/test_dest/dir')).to be true
    end
  end

  describe '.get_ctime' do

    it 'can get the month from a file' do
      subject.collect_file_names
      time = subject.get_ctime(subject.files[0])
      expect(subject.get_month(time)).to eql('November')
    end

    it 'can get the year from a file' do
      subject.collect_file_names
      time = subject.get_ctime(subject.files[0])
      expect(subject.get_year(time)).to eql('2018')
    end
  end

  describe '.create_directory_if_not_exists' do

    it "create the year and month directories if they don't exist" do
      year_dir = '/Users/rory/code/pic_wizard/test_dest/2018'
      month_dir = '/Users/rory/code/pic_wizard/test_dest/2018/November'
      expect(Dir.exists?(year_dir)).to be false
      expect(Dir.exists?(month_dir)).to be false
      subject.create_directory_if_not_exists('IMG_0965.PNG')
      expect(Dir.exists?(year_dir)).to be true
      expect(Dir.exists?(month_dir)).to be true
    end
  end

  describe '.copy_file' do

    it 'copies file to source' do
      destination_root = '/Users/rory/code/pic_wizard/test_dest'
      file_name = 'IMG_0965.PNG'
      subject.collect_file_names
      subject.create_directory_if_not_exists(file_name)
      subject.copy_file(file_name)
      expect(File.exists?(destination_root + '/' + file_name))
    end
  end

  describe '.process' do

    it 'creates all directories and copies all files' do
      subject.collect_file_names
      subject.files.each do |f|
        path = subject.source + '/' + f
        atime = File.atime(path)
        puts File.utime(atime, atime, path)
      end
    end
  end

end
