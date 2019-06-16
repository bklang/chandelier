"""Platform for light integration."""
import logging
import requests

import voluptuous as vol

import homeassistant.helpers.config_validation as cv
# Import the device class from the component that you want to support
from homeassistant.components.light import (
    ATTR_BRIGHTNESS, PLATFORM_SCHEMA, Light)
#from homeassistant.const import CONF_HOST, CONF_PASSWORD, CONF_USERNAME

_LOGGER = logging.getLogger(__name__)

# Validation of the user's configuration
PLATFORM_SCHEMA = PLATFORM_SCHEMA.extend({
    #vol.Required(CONF_HOST): cv.string,
    #vol.Optional(CONF_USERNAME, default='admin'): cv.string,
    #vol.Optional(CONF_PASSWORD): cv.string,
})


def setup_platform(hass, config, add_entities, discovery_info=None):
    """Set up the Awesome Light platform."""

    # Add devices
    lights = [0,1,2,3,4,5,6,7,8,9]
    add_entities(ChandelierBulb(light) for light in lights)


class ChandelierBulb(Light):
    """Representation of a bulb in the Chandelier."""

    def __init__(self, idx):
        """Initialize a ChandelierBulb."""
        self._name = "Chandelier Bulb %d" % idx
        self._idx = idx
        self._state = None

    @property
    def name(self):
        """Return the display name of this light."""
        return self._name

    @property
    def is_on(self):
        """Return true if light is on."""
        return self._state

    def turn_on(self, **kwargs):
        """Instruct the light to turn on.

        You can skip the brightness part if your light does not support
        brightness control.
        """
        self._state = True
        requests.post("http://chandelier.local:4000/api/switch", data = {"light": self._idx, "direction": "on"})

    def turn_off(self, **kwargs):
        """Instruct the light to turn off."""
        self._state = False
        requests.post("http://chandelier.local:4000/api/switch", data = {"light": self._idx, "direction": "off"})

    def update(self):
        """Fetch new state data for this light.

        This is the only method that should fetch new data for Home Assistant.
        """
