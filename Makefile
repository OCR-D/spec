json: \
	bagit-profile.json \
	ocrd_tool.schema.json \
	openapi.json

deps:
	pip install yaml click

%.json: %.yml
	python3 scripts/yaml-to-json.py $< $@
