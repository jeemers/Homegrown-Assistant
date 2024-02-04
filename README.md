# Homegrown-Assistant
Homegrown Assistant is a Home-assistant and ESPHome based collection of sensors, data-logging tools, and automations to monitor, log, and control a grow room.

This is kind of a journal of the project for now.
This project began as a simple monitoring and data-logging setup, based on Home Assistant, BLE temperature /humidity sensors and variety of HA-supported smart plugs.
Just having historical temperature, humidity and VPD data enabled me to modify my venthilation strategies to better maintain a more solid VPD, which helped overall plant health.
Eventually I added capacitive soil moisture sensors, to get an idea of the moisture retention curves in my grow pots - they are difficult to calibrate, to an accurate degree, but they can give trend data, which then helps learn when you need to water and when you may be giving too much water.
Eventually I started adopting "crop steering" irrigation techniques as well, using smart outlets to control shot volumes down to the mililiter, based on the holding capacity  of the media.
Crop steering irrigations had a large impact on overall vigor and yields in my garden, even when just doing basic time-based irrigations.

After some time, the THC-S sensor came to my attention and I snagged one and got much more reliable moisture readings, as well as conductivity and thus pwEC readings from the media itself.
The moisture readings are much more accurate than the capacitive sensors. The conductivity and pwEC calibrations were done against an industry standard Teros12, and there are plans to further calibrate them with other higher-end sensors in the future.
The THC-S sensor is not without it's faults and quirks, but so are all the industry sensors, but its main advantage is price, at around $30 per sensor, the cost is a fraction of any commercial options available.
However, it enabled me to create automations to more closely mimic the crop steering examples from different manufacturers, and have it mostly based on the sensor readings from the THC-S. This was a double edged sword, because that much control got the plants to vigor levels I'd never experienced, so it has been a steep learning curve since then, but keeping things simple seems to be the way to go.

After the addition of the THC-S sensor, I started paying attention to ventilation again and added an AC-Infinity fan to the tent with speed controlled by HA, based on a PID loop tracking VPD. Once that was dialed in, it really smoothed ou the RH spikes at lights off, and helped maintain a stead day/night VPD.

Then i started working on auto-filling the reservoir and auto-dosing with stock solutions and pumps. 
I built some peristaltic pumps and cobbled together some basic automations to dose the reservoir based on ml/l, and total ml of water added.
The reservoir volume is tracked via a pressure sensor scale below it, and an ultrasonic range detector in the lid above it.
To finish auto-fill, I need to add min and max switches to the res with non-contact IR liquid detectors, and plumb the system.

Currently took a detour to work on pH automation, and the safest methods to do that.
