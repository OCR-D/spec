json: $(shell find -name '*.json')

%.json: %.yml
	python3 scripts/yaml-to-json.py --indent 0 $< $@

validate: json
	jsonschema --output pretty --validator Draft201909Validator --instance ocrd_eval.sample.json ocrd_eval.schema.json

deps:
	pip install pyyaml click jsonschema
