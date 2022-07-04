"""Platform for chandelier light integration."""
from __future__ import annotations

import logging

import voluptuous as vol
import requests

# Import the device class from the component that you want to support
import homeassistant.helpers.config_validation as cv
from homeassistant.components.light import (ATTR_BRIGHTNESS, PLATFORM_SCHEMA,
                                            LightEntity)
#from homeassistant.const import CONF_HOST, CONF_PASSWORD, CONF_USERNAME
from homeassistant.core import HomeAssistant
from homeassistant.helpers.entity_platform import AddEntitiesCallback
from homeassistant.helpers.typing import ConfigType, DiscoveryInfoType

_LOGGER = logging.getLogger(__name__)

# Validation of the user's configuration
PLATFORM_SCHEMA = PLATFORM_SCHEMA.extend({
    #vol.Required(CONF_HOST): cv.string,
    #vol.Optional(CONF_USERNAME, default='admin'): cv.string,
    #vol.Optional(CONF_PASSWORD): cv.string,
})


def setup_platform(
    hass: HomeAssistant,
    config: ConfigType,
    add_entities: AddEntitiesCallback,
    discovery_info: DiscoveryInfoType | None = None
) -> None:
    """Set up the Chandelier Light platform."""
    _LOGGER.info("Setting up Chandelier")

    # Add devices
    lights = ["chandelier"]
    add_entities(Chandelier(light) for light in lights)


class Chandelier(LightEntity):
    """Representation of a Chandelier."""

    def __init__(self, idx):
        """Initialize a Chandelier."""
        _LOGGER.info("Adding chandelier %s" % idx)
        self._name = idx
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
        requests.post("http://chandelier.local:4000/api/set", data = {"id": self._idx, "value": 1})

    def turn_off(self, **kwargs):
        """Instruct the light to turn off."""
        self._state = False
        requests.post("http://chandelier.local:4000/api/set", data = {"id": self._idx, "value": 0})

    def update(self):
        """Fetch new state data for this light.

        This is the only method that should fetch new data for Home Assistant.
        """
