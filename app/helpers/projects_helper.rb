module ProjectsHelper
  def distribution_platform_icon_name platform
    case platform
    when 'web'
      'tab'
    when 'android'
      'android'
    end
  end

  def distribution_archive_download_url distribution
    # TODO proper name based on project name, platform, git hash, release version, timestamp, etc

    filename = "#{distribution.project.name}-#{distribution.platform}"
    extname = case distribution.platform
              when 'web'
                'zip'
              when 'android'
                'apk'
              end
    distribution.uploaded_archive_url + "?attname=#{filename}.#{extname}"
  end
end
