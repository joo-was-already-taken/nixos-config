#!/usr/bin/env python3

import pulsectl
import pulsectl_asyncio
import asyncio
import contextlib
import signal
import json
import argparse

def print_data(sink_info, print_json):
    volume = (sum(sink_info.volume.values) / len(sink_info.volume.values)) * 100.0
    mute_status = 'Muted' if sink_info.mute else 'Unmuted'
    data = {'sink': sink_info.name, 'volume': round(volume), 'mute_status': mute_status}
    if print_json:
        print(json.dumps(data), flush=True)
    else:
        print(*data.values(), flush=True)

async def print_initial_volume(print_json):
    async with pulsectl_asyncio.PulseAsync('initial-volume-check') as pulse:
        sinks = await pulse.sink_list()
        print_data(sinks[0], print_json)

async def listen(print_json):
    async with pulsectl_asyncio.PulseAsync('volume-change-listener') as pulse:
        async for event in pulse.subscribe_events('sink'):
            if event.t == pulsectl.PulseEventTypeEnum.change:
                sinks = await pulse.sink_list()
                sink_info = next((s for s in sinks if s.index == event.index), None)
                print_data(sink_info, print_json)

async def main():
    parser = argparse.ArgumentParser(prog='pulse-volume-listener')
    parser.add_argument('-j', '--json', action='store_true')
    parser.add_argument('-i', '--initial', action='store_true')
    args = parser.parse_args()

    if args.initial:
        await print_initial_volume(args.json)

    listen_task = asyncio.create_task(listen(args.json))

    loop = asyncio.get_running_loop()
    for sig in (signal.SIGTERM, signal.SIGHUP, signal.SIGINT):
        loop.add_signal_handler(sig, listen_task.cancel)

    with contextlib.suppress(asyncio.CancelledError):
        await listen_task

if __name__ == '__main__':
    asyncio.run(main())
