# class RawGit
#   # https://rawgit.com/
#
#   # Use this URL in production
#   # https://cdn.rawgit.com/user/repo/tag/file
#   # - No traffic limits or throttling. Files are served via MaxCDN's super fast global CDN.
#   # - Use a specific tag or commit hash in the URL (not a branch). Files are cached permanently based on the URL. Query strings are ignored.
#   # - The catch: this is a free service, so there are no uptime or support guarantees.
#
#   # Use this URL for development
#   # https://rawgit.com/user/repo/branch/file
#   # - New changes you push to GitHub will be reflected within minutes.
#   # - Excessive traffic will be throttled and blacklisted.
#   # - If excessive traffic continues, RawGit will display a prominent error message on your website to try to get your attention.
#
#   # URL_PATTERN_IN_PRODUCTION = 'https://cdn.rawgit.com/user/repo/tag/file'
#   # URL_PATTERN_IN_DEVELOPMENT = 'https://rawgit.com/user/repo/branch/file'
#
#   URL_PATTERN_IN_PRODUCTION = "https://cdn.rawgit.com/%{owner}/%{repo}/%{branch}/%{file_path}"
#   URL_PATTERN_IN_DEVELOPMENT = "https://rawgit.com/%{owner}/%{repo}/%{branch}/%{file_path}"
#
#   # TODO HACK
#   # currently we're using the branch instead of tag in production mode,
#   # which is NOT recommended, but seems working
#   def self.path_for(owner:, repo:, branch: 'master', file_path:)
#     url_pattern = self.const_get "URL_PATTERN_IN_#{Rails.env.upcase}"
#     url = url_pattern % { owner: owner, repo: repo, branch: branch, file_path: file_path }
#   end
# end
