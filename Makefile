json: $(shell find -name '*.json')

%.json: %.yml
	python3 scripts/yaml-to-json.py $< $@

validate: json
	jsonschema --output pretty --validator Draft201909Validator --instance ocrd_eval.sample.json ocrd_eval.schema.json

deps:
	pip install yaml click jsonschema
