#  The version for use with C and Oracle follows:

include ../../Environ
include make_include

######################### Directives ###############################

TARGET = $(HDB_APP_BIN)/shef_forecast_hdb
OBJS = \
		$(OBJDIR)/shef_forecast_hdb.o

main: $(TARGET) links

$(TARGET): $(OBJS)
	$(CC) $(OBJS) $(LIBS) -luc -o $(TARGET)

$(OBJDIR)/shef_forecast_hdb.o: \
					shef_forecast_hdb.c \
					shef_forecast_hdb.h \
					$(HDB_APP_LIB)/libhdb.a \
					$(HDB_APP_LIB)/libutils.a
	$(CC) $(CFLAGS) -c shef_forecast_hdb.c -o $@

links:
	cd $(HDB_APP_BIN) ; \
	rm -f forecast2hdb.sh ; \
	ln -s ../shef_forecast_hdb/src/forecast2hdb.sh forecast2hdb.sh ; \
	cd ../shef_forecast_hdb/src/ ; \
	cd ./shef ; \
	make ; \
	cd $(HDB_APP_BIN) ; \
	rm -f shef_decode ; \
	ln -s ../shef_forecast_hdb/src/shef/shef_decode shef_decode ; \
	cd ../shef_forecast_hdb/src/

clean:
	rm -f $(OBJS) $(TARGET)
