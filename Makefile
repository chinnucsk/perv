
REBAR=$(shell which rebar || echo ./rebar)

all: dirs deps compile

./rebar:
	erl -noshell -s inets start -s ssl start  \
		-eval 'httpc:request(get, {"https://github.com/downloads/basho/rebar/rebar", []}, [], [{stream, "./rebar"}])' \
		-s init stop
	chmod +x ./rebar

dirs:
	@mkdir -p priv/tmp priv/log priv/files/image

deps: $(REBAR)
	@$(REBAR) get-deps

compile: $(REBAR)
	@$(REBAR) compile

clean: $(REBAR)
	@$(REBAR) clean

