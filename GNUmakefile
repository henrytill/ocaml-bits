.SUFFIXES:

PREFIX = /usr/local

FUZZ = afl-fuzz
OCAMLC = ocamlc
OCAMLOPT = ocamlopt
OCAMLMKTOP = ocamlmktop
OCAMLDEP = ocamldep
OCAMLFIND = ocamlfind
OPAM = opam

INCLUDES =

OCAMLFLAGS =
OCAMLOPTFLAGS = -g
OCAMLFINDFLAGS =

BIN =
BIN += delimcc_test
BIN += delimcc_top
BIN += hlist_test
BIN += landins_knot
BIN += lenses
BIN += readline
BIN += sqlite_test

STATIC_BIN =
STATIC_BIN += delimcc_test
STATIC_BIN += sqlite_test

-include config.mk

all: $(BIN)

.SUFFIXES: .mli .cmi
.mli.cmi:
	$(OCAMLFIND) $(OCAMLOPT) $(OCAMLOPTFLAGS) -o $@ $<

.SUFFIXES: .ml .cmo
.ml.cmo:
	$(OCAMLFIND) $(OCAMLC) $(OCAMLOPTFLAGS) -c $(OCAMLFINDFLAGS) $<

.SUFFIXES: .ml .cmx
.ml.cmx:
	$(OCAMLFIND) $(OCAMLOPT) $(OCAMLOPTFLAGS) -c $(OCAMLFINDFLAGS) $<

delimcc_test: OCAMLOPTFLAGS += -w -58
delimcc_test: OCAMLFINDFLAGS += -linkpkg -package delimcc
delimcc_test: delimcc_tutorial.cmx delimcc_test.cmx
	$(OCAMLFIND) $(OCAMLOPT) $(OCAMLOPTFLAGS) -o $@ $(OCAMLFINDFLAGS) $^

delimcc_top: OCAMLFINDFLAGS += -linkpkg -package delimcc
delimcc_top: delimcc_tutorial.cmo
	$(OCAMLFIND) $(OCAMLMKTOP) -o $@ $(OCAMLFINDFLAGS) $<

hlist_test: hlist.cmx hlist_test.cmx
	$(OCAMLFIND) $(OCAMLOPT) $(OCAMLOPTFLAGS) -o $@ $(OCAMLFINDFLAGS) $^

readline: OCAMLOPTFLAGS += -afl-instrument
readline: readline.ml

sqlite_test: OCAMLFINDFLAGS += -linkpkg -package sqlite3
sqlite_test: sqlite_test.cmx
	$(OCAMLFIND) $(OCAMLOPT) $(OCAMLOPTFLAGS) -o $@ $(OCAMLFINDFLAGS) $^

.SUFFIXES: .ml
.ml:
	$(OCAMLOPT) $(OCAMLOPTFLAGS) -o $@ $<

input:
	mkdir -p $@

input/testcase: input
	echo asdf > $@

.PHONY: fuzz
fuzz: readline input/testcase
	$(FUZZ) -m none -i input -o output ./readline

.PHONY: install
install: delimcc_test sqlite_test
	mkdir -p $(PREFIX)/bin
	install -m 755 delimcc_test $(PREFIX)/bin/delimcc_test
	install -m 755 sqlite_test $(PREFIX)/bin/sqlite_test

.PHONY: clean
clean:
	rm -rf input output
	rm -f $(BIN)
	rm -f *.cm[iox]
	rm -f *.o

.PHONY: static
static: clean
	sh build-static-exe.sh $(STATIC_BIN)

.depend: *.mli *.ml GNUmakefile
	$(OCAMLDEP) $(INCLUDES) *.mli *.ml > $@

include .depend

FORCE:
