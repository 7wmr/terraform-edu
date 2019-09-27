# Minimal makefile for Sphinx documentation
#

# You can set these variables from the command line.
SPHINXOPTS    =
SPHINXBUILD   = sphinx-build
SOURCEDIR     = docs/src
BUILDDIR      = docs/_build

# Create html documentation in the docs/gh-pages subtree path
html:
	@$(SPHINXBUILD) -M html "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)
	@cp -R $(BUILDDIR)/html/ ./docs/gh-pages
	@touch ./docs/gh-pages/.nojekyll
	@echo "terraform-edu.7wmr.uk" > ./docs/gh-pages/CNAME

# This will push the docs/gh-pages folder to the gh-pages branch
pages:
	@git subtree push --prefix docs/gh-pages origin gh-pages


.PHONY: help Makefile

# Catch-all target: route all unknown targets to Sphinx using the new
# "make mode" option.  $(O) is meant as a shortcut for $(SPHINXOPTS).
%: Makefile
	@$(SPHINXBUILD) -M $@ "$(SOURCEDIR)" "$(BUILDDIR)" $(SPHINXOPTS) $(O)
