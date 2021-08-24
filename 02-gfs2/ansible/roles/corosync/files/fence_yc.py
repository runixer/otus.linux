#!/usr/bin/python3

import sys
import logging
import atexit
sys.path.append("/usr/share/fence")
from fencing import fail_usage, run_delay, SyslogLibHandler
from fencing import *

import grpc
import yandexcloud
from yandex.cloud.compute.v1.instance_pb2 import Instance
from yandex.cloud.compute.v1.instance_service_pb2 import (
	ListInstancesRequest, GetInstanceRequest, StartInstanceRequest, StopInstanceRequest
)
from yandex.cloud.compute.v1.instance_service_pb2_grpc import InstanceServiceStub

logger = logging.getLogger("fence_aws")
logger.propagate = False
logger.setLevel(logging.INFO)
logger.addHandler(SyslogLibHandler())

def define_new_opts():
	all_opt["folder_id"] = {
		"getopt": "f:",
		"longopt": "folder",
		"help": "-f, --folder=[id]              Yandex.Cloud folder id, e.g. b1g8mtna1s4uadii3a8a",
		"shortdesc": "Folder.",
		"required": "1",
		"order": 2
	}

def translate_status(instance_status):
	"Returns on | off | unknown."
	if instance_status == 2:		# RUNNING
		return "on"
	elif instance_status == 4:  # STOPPED
		return "off"
	return "unknown"

def get_nodes_list(conn, options):
	logger.info("Starting monitor operation")
	result = {}
	try:
		answer = conn.List(ListInstancesRequest(folder_id=options["--folder"]))
	except Exception as e:
		logger.error("Failed: List Instances from Yandex Cloud:\n" + str(e))
	for instance in answer.instances:
		result[instance.id] = (instance.name, translate_status(instance.status))
	return result

def get_power_status(conn, options):
	logger.debug("Starting status operation")
	state = "unknown"
	try:
		answer = conn.Get(GetInstanceRequest(instance_id=options["--plug"]))
		state = translate_status(answer.status)
	except Exception as e:
		logger.error("Failed: Get Instance from Yandex Cloud %s: %s\n",
		             options["--plug"], e)
	return state

def set_power_status(conn, options):
	logger.debug("Starting power operation")
	try:
		if (options["--action"] == "off"):
			conn.Stop(StopInstanceRequest(instance_id=options["--plug"]))
		elif (options["--action"] == "on"):
			conn.Start(StartInstanceRequest(instance_id=options["--plug"]))
	except Exception as e:
		logger.error("Failed to power %s %s: %s", options["--action"], options["--plug"], e)

def main():
	conn = None

	device_opt = ["port", "no_password", "folder_id"]

	atexit.register(atexit_handler)

	define_new_opts()

	all_opt["power_timeout"]["default"] = "60"
	all_opt["method"]["default"] = "cycle"
	all_opt["method"]["help"] = "-m, --method=[method]          Method to fence (onoff|cycle) (Default: cycle)"

	options = check_input(device_opt, process_input(device_opt))

	docs = {}
	docs["shortdesc"] = "Fence agent for YC (Yandex Cloud)"
	docs["longdesc"] = "fence_yc is an I/O Fencing agent for YC (Yandex Cloud). " \
			"It uses the yandexcloud library to connect to YC.\n" \

	docs["vendorurl"] = "https://cloud.yandex.com"
	show_docs(options, docs)

	run_delay(options)

	if options.get("--verbose") is not None:
		lh = logging.FileHandler('/var/log/fence_yc_debug.log')
		logger.addHandler(lh)
		lhf = logging.Formatter(
							'%(asctime)s - %(name)s - %(levelname)s - %(message)s')
		lh.setFormatter(lhf)
		logger.setLevel(logging.DEBUG)

	interceptor = yandexcloud.RetryInterceptor(
			max_retry_count=5, retriable_codes=[grpc.StatusCode.UNAVAILABLE])

	try:
		sdk = yandexcloud.SDK(interceptor=interceptor)
		conn = sdk.client(InstanceServiceStub)
	except Exception as e:
		logger.error("Failed: Unable to connect to Yandex Cloud: " + str(e))

	# Operate the fencing device
	result = fence_action(conn, options, set_power_status, get_power_status, get_nodes_list)
	sys.exit(result)


if __name__ == "__main__":
	main()
