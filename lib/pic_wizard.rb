require 'fileutils'

class PicWizard

# fix these
  attr_accessor :source, :destination_root, :files, :months, :log, :copy_count

  def initialize
    @source = '/Users/rory/code/pic_wizard/sample_files'
    @destination_root = '/Users/rory/code/pic_wizard/test_dest'
    @files = []
    @months = {
      1 => 'January',
      2 => 'February',
      3 => 'March',
      4 => 'April',
      5 => 'May',
      6 => 'June',
      7 => 'July',
      8 => 'August',
      9 => 'September',
      10 => 'October',
      11 => 'November',
      12 => 'December'}
      @log = ''
      @copy_count = 0
  end

  def process
    collect_file_names
    self.files.each do |file_name|
      create_directory_if_not_exists(file_name)
      copy_file(file_name)
    end
    puts self.log
    puts self.copy_count
  end

  def collect_file_names
    Dir.chdir(self.source)
    self.files = Dir.glob('**/*.{HEIC,PNG,mov,mp4,jpg}')
  end

  def create_directory_if_not_exists(file_name)
    source_file_path = self.source + '/' + file_name
    time = get_ctime(source_file_path)
    year_string = get_year(time)
    month_string = get_month(time)
    dest_year = destination_dir_year(year_string)
    dest_month = destination_dir_month(dest_year, month_string)

    if (!Dir.exists?(dest_year))
      Dir.mkdir(dest_year)
      if (!Dir.exists?(dest_month))
        Dir.mkdir(dest_month)
      end
    end
  end

  def copy_file(file_name)
    full_dest_path = full_dest_path(file_name)
    full_source_path = self.source + '/' + file_name
    if (!File.exists?(full_dest_path))
      FileUtils.cp(full_source_path, full_dest_path)
    end
    self.log += "Copied #{full_source_path} to #{full_dest_path}\n"
    self.copy_count += 1
  end

  def create_directory(dir)
    Dir.mkdir(dir)
  end

  def get_ctime(file_path)
    # perhaps use .utime here
    File.ctime(file_path)
  end

  def get_month(time)
    a = self.months[time.month]
    puts a # delete this rrrrrrrrrrrrrrrrrrrrrrrr
    a
  end

  def get_year(time)
    time.year.to_s
  end

  def destination_dir_year(year_string)
    self.destination_root + '/' + year_string
  end

  def destination_dir_month(year_path, month_string)
    year_path + '/' + month_string
  end

  def full_dest_path(file_name)
    time = get_ctime(self.source + '/' + file_name)
    self.destination_root + '/' + get_year(time) + '/' + get_month(time) + '/' + file_name
  end

end
wiz = PicWizard.new
wiz.process
