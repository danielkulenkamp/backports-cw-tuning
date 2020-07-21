BP = backports-4.19.85-1

all: $(BP)
	make -C $(BP) -j8
	mkdir -p athmodules
	cp $(BP)/compat/compat.ko athmodules/
	cp $(BP)/net/mac80211/mac80211.ko athmodules/
	cp $(BP)/drivers/net/wireless/ath/ath.ko athmodules/
	cp $(BP)/drivers/net/wireless/ath/ath9k/*.ko athmodules/
	cp $(BP)/net/wireless/cfg80211.ko athmodules/

$(BP): $(BP).tar.gz
	tar xzf $(BP).tar.gz
	cd $(BP) && \
	  patch -p1 < ../backports-wireless-v3.patch && \
	  echo "CPTCFG_ATH9K_STATION_STATISTICS=y" >> defconfigs/ath9k-debug && \
	  echo "CPTCFG_MAC80211_DEBUG_COUNTERS=y"  >> defconfigs/ath9k-debug
	make -C $(BP) defconfig-ath9k-debug

$(BP).tar.gz:
	wget https://www.kernel.org/pub/linux/kernel/projects/backports/stable/v4.19.85/$(BP).tar.gz

clean:
	rm -rf $(BP)
	rm -rf athmodules
