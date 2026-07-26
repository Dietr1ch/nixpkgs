# Format
#
# Formats all files
fmt:
	nix fmt

# Build {{PACKAGE}}
#
# Builds a package
build PACKAGE:
	nix-build \
	  --verbose \
	  --attr {{PACKAGE}}


# Update {{PACKAGE}}
#
# Requires it defining its own UpdateScript
# - https://wiki.nixos.org/wiki/Nixpkgs/Update_Scripts
#
# Updates a package
update PACKAGE:
	nix-shell maintainers/scripts/update.nix \
	  --argstr skip-prompt true \
	  --argstr package {{PACKAGE}}

# Update and Commit {{PACKAGE}}
#
# Requires it defining its own UpdateScript
# - https://wiki.nixos.org/wiki/Nixpkgs/Update_Scripts
#
# Updates a package and creates its update commit
update_and_commit PACKAGE:
	nix-shell maintainers/scripts/update.nix \
	  --argstr commit true \
	  --argstr skip-prompt true \
	  --argstr package {{PACKAGE}}

# Review a nixpkgs Pull Request
pull_request_review PR:
	# Fetching {{PR}} into review/{{PR}}
	git fetch upstream pull/{{PR}}/head:review/{{PR}}
	# Reviewing {{PR}}
	nixpkgs-review pr {{PR}}
