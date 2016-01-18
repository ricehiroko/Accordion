.EXPORT_ALL_VARIABLES:


# Path to static template
TPL := demos/index.htm


# Outline of static accordion demo
OUTLINE := demos/outline.txt


# Build and inject an accordion scaffold structure in the demos folder
scaffold:
	@utils/scaffold-build.js < $(OUTLINE) | \
	tidy \
		--quiet yes \
		--indent-with-tabs yes \
		--indent yes \
		--tab-size 4 \
		--tidy-mark no \
		--show-body-only yes | \
	perl -0777 -p -e 's/\n\t+([^<\s][^<]*?)\s+/$$1/gms' | \
	perl -p -e 's/^/\t/g' | \
	perl -p -e "s/%LIPSUM%/$$(lorem-ipsum 2 paragraphs | tr -d $$'\n')/g" | \
	utils/scaffold-inject.pl $(TPL)


# Watchman triggers: Automatically update in response to filesystem changes
watch:
	@watchman watch $(PWD) > /dev/null
	@watchman -- trigger $(PWD) rebuild-scaffold $(OUTLINE) -- make scaffold > /dev/null

unwatch:
	@watchman watch-del $(PWD) > /dev/null

PWD := $(shell pwd)
