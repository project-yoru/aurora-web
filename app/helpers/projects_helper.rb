module ProjectsHelper
  def distribution_platform_icon_name distribution
    case distribution.platform
    when 'web'
      'computer'
    end
  end

  def distribution_archive_download_url distribution
    # TODO proper name based on project name, platform, git hash, release version, etc
    filename = "#{distribution.project.name}-#{distribution.platform}.zip"
    distribution.uploaded_archive_url + "?attname=#{filename}"
  end
end
