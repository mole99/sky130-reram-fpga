MAKEFILE_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

PDK ?= sky130A

# Get the fabric names
FABRICS :=  $(patsubst fabrics/%,%,$(wildcard fabrics/*)) 

FABRICS_OPENROAD := $(addsuffix -openroad,$(FABRICS))
FABRICS_KLAYOUT := $(addsuffix -klayout,$(FABRICS))
FABRICS_COPY := $(addsuffix -copy,$(FABRICS))

all: $(FABRICS)
.PHONY: all

$(FABRICS):
	librelane --pdk ${PDK} ${OPTS} fabrics/$@/config.yaml --save-views-to fabrics/$@/macro/${PDK}/
.PHONY: $(FABRICS)

$(FABRICS_OPENROAD):
	librelane --pdk ${PDK} ${OPTS} fabrics/$(subst -openroad,,$@)/config.yaml --last-run --flow OpenInOpenROAD
.PHONY: $(FABRICS_OPENROAD)

$(FABRICS_KLAYOUT):
	librelane --pdk ${PDK} ${OPTS} fabrics/$(subst -klayout,,$@)/config.yaml --last-run --flow OpenInKLayout
.PHONY: $(FABRICS_KLAYOUT)

$(FABRICS_COPY):
	# Copy fabric database
	mkdir -p user_designs/fabrics/$(subst -copy,,$@)/macro/${PDK}/
	cp -R fabrics/$(subst -copy,,$@)/macro/${PDK}/fabulous/ user_designs/fabrics/$(subst -copy,,$@)/macro/${PDK}/
	cp fabrics/$(subst -copy,,$@)/constraints.pcf user_designs/fabrics/$(subst -copy,,$@)/constraints.pcf
.PHONY: $(FABRICS_COPY)

librelane:
	librelane librelane/config.yaml --pdk ${PDK} --save-views-to macro/
.PHONY: librelane

librelane-openroad:
	librelane librelane/config.yaml --pdk ${PDK} --last-run --flow OpenInOpenROAD
.PHONY: librelane

librelane-klayout:
	librelane librelane/config.yaml --pdk ${PDK} --last-run --flow OpenInKLayout
.PHONY: librelane

librelane-copy:
	# Copy GDS and LEF
	cp macro/gds/${TOP}.gds gds/${TOP}.gds
	cp macro/lef/${TOP}.lef lef/${TOP}.lef
.PHONY: librelane-copy
