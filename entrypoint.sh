#!/bin/ash

set -e

echo "[*] Trackmania Docker Image     "
echo "[*] ----------------------------"
echo "[*] Updated for Frag-o-Matic Lan"
echo "[*] Original by EvoEsports"

# TODO: check the game runs under the trackmania user

# template files
mkdir -p templates
DC_TEMPLATE="templates/${TM_DEDICATED_CFG:-dedicated_cfg.xml}"
MS_TEMPLATE="templates/${TM_MATCH_SETTINGS:-match_settings.xml}"

# If the templates do not exist copy the default files
if [ ! -f "$DC_TEMPLATE" ]; then
	cp "UserData/Config/dedicated_cfg.default.txt" "$DC_TEMPLATE"
fi

if [ ! -f "$MS_TEMPLATE" ]; then
	cp "UserData/Maps/MatchSettings/example.txt" "$MS_TEMPLATE"
fi

# The locations where the templates will be finally moved
DC_FILE="dedicated_cfg.xml"
DC_PATH="UserData/Config/$DC_FILE"

MS_FILE=match_settings.xml
MS_PATH="UserData/Maps/MatchSettings/$MS_FILE"

# Move the files
cp "$DC_TEMPLATE" "$DC_PATH"
cp "$MS_TEMPLATE" "$MS_PATH"

# edit setting in dedicated config
edit_dc() {
	if [ "$2" ]; then
		xml edit -L -u "$1" -v "$2" "$DC_PATH"
	fi
}

# edit setting in match settings
edit_ms() {
	xml edit -L -u "$1" -v "$2" "$MS_PATH"
}

# /dedicated/authorization_levels/*
BASE_XML=/dedicated/authorization_levels
		
edit_dc "$BASE_XML/level[1]/password" "${TM_AUTHORIZATION_SUPERADMIN_PASSWORD}"
edit_dc "$BASE_XML/level[2]/password" "${TM_AUTHORIZATION_ADMIN_PASSWORD}"
edit_dc "$BASE_XML/password" "${TM_AUTHORIZATION_USER_PASSWORD}"

# /dedicated/masterserver_account/*
BASE_XML=/dedicated/masterserver_account

edit_dc "$BASE_XML/login" "${TM_MASTERSERVER_LOGIN}"

TM_MASTERSERVER_PASSWORD=$(echo "${TM_MASTERSERVER_PASSWORD}" | sed -e 's/\$/\\\$/g' -e 's/`/\\`/g');
edit_dc "$BASE_XML/password" "${TM_MASTERSERVER_PASSWORD}"
	
# /dedicated/server_options/*
edit_dc '/dedicated/server_options/name' "$TM_SERVER_NAME"
edit_dc '/dedicated/server_options/login' "${TM_SERVER_COMMENT}"
edit_dc '/dedicated/server_options/max_players' "${TM_SERVER_MAX_PLAYERS}"
edit_dc '/dedicated/server_options/password' "${TM_SERVER_PASSWORD}"
edit_dc '/dedicated/server_options/max_spectators' "${TM_SERVER_MAX_SPECTATORS}"
edit_dc '/dedicated/server_options/password_spectator' "${TM_SERVER_PASSWORD_SPECTATOR}"
edit_dc '/dedicated/server_options/keep_player_slots' "${TM_SERVER_KEEP_PLAYER_SLOTS}"
edit_dc '/dedicated/server_options/ladder_mode' "${TM_SERVER_LADDER_MODE}"
edit_dc '/dedicated/server_options/enable_p2p_upload' "${TM_SERVER_ENABLE_P2P_UPLOAD}"
edit_dc '/dedicated/server_options/enable_p2p_download' "${TM_SERVER_ENABLE_P2P_DOWNLOAD}"
edit_dc '/dedicated/server_options/callvote_timeout' "${TM_SERVER_CALLVOTE_TIMEOUT}"
edit_dc '/dedicated/server_options/callvote_ratio' "${TM_SERVER_CALLVOTE_RATIO}"
# Ratios
edit_dc '/dedicated/server_options/allow_map_download' "${TM_SERVER_ALLOW_MAP_DOWNLOAD}"
edit_dc '/dedicated/server_options/autosave_replays' "${TM_SERVER_AUTOSAVE_REPLAYS}"
edit_dc '/dedicated/server_options/autosave_validation_replays' "${TM_SERVER_AUTOSAVE_VALIDATION_REPLAYS}"	
edit_dc '/dedicated/server_options/referee_password' "${TM_SERVER_REFEREE_PASSWORD}"
edit_dc '/dedicated/server_options/referee_validation_mode' "${TM_SERVER_REFEREE_VALIDATION_MODE}"
edit_dc '/dedicated/server_options/use_changing_validation_seed' "${TM_SERVER_USE_CHANGING_VALIDATION_SEED}"
edit_dc '/dedicated/server_options/disable_horns' "${TM_SERVER_DISABLE_HORNS}"
edit_dc '/dedicated/server_options/disable_profile_skins' "${TM_SERVER_DISABLE_PROFILE_SKINS}"
edit_dc '/dedicated/server_options/clientinputs_maxlatency' "${TM_SERVER_CLIENTINPUTS_MAXLATENCY}"

# /dedicated/system_config/*
edit_dc '/dedicated/system_config/connection_uploadrate' "${TM_SYSTEM_CONNECTION_UPLOADRATE}"
edit_dc '/dedicated/system_config/connection_downloadrate' "${TM_SYSTEM_CONNECTION_DOWNLOADRATE}"
edit_dc '/dedicated/system_config/workerthreadcount' "${TM_SYSTEM_WORKERTHREADCOUNT}"
edit_dc '/dedicated/system_config/packetassembly_multithread' "${TM_SYSTEM_PACKETASSEMBLY_MULTITHREAD}"
edit_dc '/dedicated/system_config/packetassembly_packetsperframe' "${TM_SYSTEM_PACKETASSEMBLY_PACKETSPERFRAME}"
edit_dc '/dedicated/system_config/packetassembly_fullpacketsperframe' "${TM_SYSTEM_PACKETASSEMBLY_FULLPACKETSPERFRAME}"
edit_dc '/dedicated/system_config/delayedvisuals_s2c_sendingrate' "${TM_SYSTEM_DELAYEDVISUALS_S2C_SENDINGRATE}"
edit_dc '/dedicated/system_config/delayedvisuals_restricttospectators' "${TM_SYSTEM_DELAYEDVISUALS_RESTRICTTOSPECTATORS}"
edit_dc '/dedicated/system_config/trustclientsimu_c2s_sendingrate' "${TM_SYSTEM_TRUSTCLIENTSIMU_C2S_SENDINGRATE}"
edit_dc '/dedicated/system_config/allow_spectator_relays' "${TM_SYSTEM_ALLOW_SPECTATOR_RELAYS}"
edit_dc '/dedicated/system_config/p2p_cache_size' "${TM_SYSTEM_P2P_CACHE_SIZE}"
edit_dc '/dedicated/system_config/force_ip_address' "${TM_SYSTEM_FORCE_IP_ADDRESS}"
edit_dc '/dedicated/system_config/server_port' "${TM_SYSTEM_SERVER_PORT}"
edit_dc '/dedicated/system_config/bind_ip_address' "${TM_SYSTEM_BIND_IP_ADDRESS}"
edit_dc '/dedicated/system_config/use_nat_upnp' "${TM_SYSTEM_USE_NAT_UPNP}"
edit_dc '/dedicated/system_config/gsp_name' "${TM_SYSTEM_GSP_NAME}"
edit_dc '/dedicated/system_config/gsp_url' "${TM_SYSTEM_GSP_URL}"
edit_dc '/dedicated/system_config/xmlrpc_port' "${TM_SYSTEM_XMLRPC_PORT}"
edit_dc '/dedicated/system_config/xmlrpc_allowremote' "${TM_SYSTEM_XMLRPC_ALLOWREMOTE}"
edit_dc '/dedicated/system_config/blacklist_url' "${TM_SYSTEM_BLACKLIST_URL}"
edit_dc '/dedicated/system_config/guestlist_filename' "${TM_SYSTEM_GUESTLIST_FILENAME}"
edit_dc '/dedicated/system_config/blacklist_filename' "${TM_SYSTEM_BLACKLIST_FILENAME}"
edit_dc '/dedicated/system_config/minimum_client_build' "${TM_SYSTEM_MINIMUM_CLIENT_BUILD}"
edit_dc '/dedicated/system_config/disable_coherence_checks' "${TM_SYSTEM_DISABLE_COHERENCE_CHECKS}"
edit_dc '/dedicated/system_config/disable_replay_recording' "${TM_SYSTEM_DISABLE_REPLAY_RECORDING}"
edit_dc '/dedicated/system_config/save_all_individual_runs' "${TM_SYSTEM_SAVE_ALL_INDIVIDUAL_RUNS}"
edit_dc '/dedicated/system_config/use_proxy' "${TM_SYSTEM_USE_PROXY}"
edit_dc '/dedicated/system_config/proxy_url' "${TM_SYSTEM_PROXY_URL}"


		# write voteratios
		# if [ "$TM_SERVER_CALLVOTE_RATIOS" ]; then
		#    IFS=' ' read -r -a voteratio_array <<< "$TM_SERVER_CALLVOTE_RATIOS"
#
#		    for voteratio in "${voteratio_array[@]}"; do
#		        command="${voteratio%%:*}"
#		        ratio="${voteratio#*:}"
#
#		        xmlstarlet ed -L -P \
#		            -u "/dedicated/server_options/callvote_ratios/voteratio[@command='${command}']/@ratio" -v "${ratio}" \
#		            -s "/dedicated/server_options/callvote_ratios[not(voteratio[@command='${command}'])]" -t elem -n "voteratio" -v "" \
#		            -i "/dedicated/server_options/callvote_ratios/voteratio[not(@command)]" -t attr -n "command" -v "${command}" \
#		            -i "/dedicated/server_options/callvote_ratios/voteratio[@command='${command}' and not(@ratio)]" -t attr -n "ratio" -v "${ratio}" \
#		            /server/UserData/Config/"${DC:-dedicated_cfg.txt}"
#		    done

#		    filter_expr=""
#		    for voteratio in "${voteratio_array[@]}"; do
#		        command="${voteratio%%:*}"
#		        filter_expr+="not(@command='${command}') and "
#		    done

#		    filter_expr="${filter_expr% and }"
#		    xmlstarlet ed -L -P \
#		        -d "/dedicated/server_options/callvote_ratios/voteratio[${filter_expr}]" \
#		        /server/UserData/Config/"${DC:-dedicated_cfg.txt}"
#		fi

# fire up the promehteus exporter
if [ "$PROMETHEUS_ENABLE" = true ] || [ "$PROMETHEUS_ENABLE" = True ]; then
    echo "[+] Using Prometheus exporter."
    ./trackmania_exporter &
fi

exec ./TrackmaniaServer /dedicated_cfg="$DC_FILE" /game_settings=MatchSettings/"$MS_FILE" /noDaemon
