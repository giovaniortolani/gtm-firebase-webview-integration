___INFO___

{
  "type": "TAG",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "Prototype Firebase + GTM Interface",
  "categories": [
    "ANALYTICS",
    "ADVERTISING",
    "MARKETING"
  ],
  "brand": {
    "id": "brand_dummy",
    "displayName": ""
  },
  "description": "",
  "containerContexts": [
    "WEB"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "runningInNativeWebiew",
    "displayName": "Signal that indicates that the container is running inside of a webview",
    "simpleValueType": true
  },
  {
    "type": "SELECT",
    "name": "command",
    "displayName": "Command",
    "macrosInSelect": false,
    "selectItems": [
      {
        "value": "setUserProperty",
        "displayValue": "setUserProperty"
      },
      {
        "value": "logEvent",
        "displayValue": "logEvent"
      },
      {
        "value": "setDefaultEventParameters",
        "displayValue": "setDefaultEventParameters"
      },
      {
        "value": "setUserId",
        "displayValue": "setUserId"
      }
    ],
    "simpleValueType": true,
    "valueValidators": [
      {
        "type": "NON_EMPTY"
      }
    ],
    "subParams": [
      {
        "type": "TEXT",
        "name": "eventName",
        "displayName": "Event Name",
        "simpleValueType": true,
        "enablingConditions": [
          {
            "paramName": "command",
            "paramValue": "logEvent",
            "type": "EQUALS"
          }
        ],
        "alwaysInSummary": false
      },
      {
        "type": "TEXT",
        "name": "userId",
        "displayName": "User ID",
        "simpleValueType": true,
        "enablingConditions": [
          {
            "paramName": "command",
            "paramValue": "setUserId",
            "type": "EQUALS"
          }
        ],
        "alwaysInSummary": false
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "parametersGroup",
    "displayName": "Event Parameters",
    "groupStyle": "ZIPPY_OPEN",
    "subParams": [
      {
        "type": "SELECT",
        "name": "parametersFromVariable",
        "displayName": "Load Parameters From Variable",
        "macrosInSelect": true,
        "selectItems": [
          {
            "value": false,
            "displayValue": "False"
          }
        ],
        "simpleValueType": true,
        "help": "You can use a variable that returns a JavaScript object with the parameters you want to set. This object will be merged with any additional parameters you set via the table below. Any conflicts will be resolved in favor of the parameters you add to the table."
      },
      {
        "type": "SIMPLE_TABLE",
        "name": "parametersList",
        "displayName": "",
        "simpleTableColumns": [
          {
            "defaultValue": "",
            "displayName": "Field Name",
            "name": "name",
            "type": "TEXT",
            "valueValidators": [
              {
                "type": "NON_EMPTY"
              },
              {
                "type": "REGEX",
                "args": [
                  "[a-z_\\.\\-]{1,40}"
                ]
              }
            ]
          },
          {
            "defaultValue": "",
            "displayName": "Value",
            "name": "value",
            "type": "TEXT"
          }
        ]
      }
    ],
    "enablingConditions": [
      {
        "paramName": "command",
        "paramValue": "logEvent",
        "type": "EQUALS"
      },
      {
        "paramName": "command",
        "paramValue": "setDefaultEventParameters",
        "type": "EQUALS"
      }
    ]
  },
  {
    "type": "GROUP",
    "name": "userPropertiesGroup",
    "displayName": "User Properties",
    "groupStyle": "ZIPPY_OPEN",
    "subParams": [
      {
        "type": "SELECT",
        "name": "userPropertiesFromVariable",
        "displayName": "Load Properties From Variable",
        "macrosInSelect": true,
        "selectItems": [
          {
            "value": false,
            "displayValue": "False"
          }
        ],
        "simpleValueType": true,
        "help": "You can use a variable that returns a JavaScript object with the properties you want to use. This object will be merged with any additional properties you add via the table below. Any conflicts will be resolved in favor of the properties you add to the table."
      },
      {
        "type": "SIMPLE_TABLE",
        "name": "userPropertiesList",
        "displayName": "",
        "simpleTableColumns": [
          {
            "defaultValue": "",
            "displayName": "Property Name",
            "name": "name",
            "type": "TEXT",
            "valueValidators": [
              {
                "type": "NON_EMPTY"
              },
              {
                "type": "REGEX",
                "args": [
                  "[a-z_]{1,40}"
                ]
              }
            ]
          },
          {
            "defaultValue": "",
            "displayName": "Value",
            "name": "value",
            "type": "TEXT"
          }
        ]
      }
    ],
    "enablingConditions": [
      {
        "paramName": "command",
        "paramValue": "setUserProperty",
        "type": "EQUALS"
      }
    ]
  }
]


___SANDBOXED_JS_FOR_WEB_TEMPLATE___

const callInWindow = require('callInWindow');
const getType = require('getType');
const logToConsole = require('logToConsole');
const Object = require('Object');
const makeTableMap = require('makeTableMap');

logToConsole('[Prototype Firebase + GTM Interface] | ', 'data: ', data);

const runningInNativeWebview = data.runningInNativeWebiew;

/**
 * Turns an object literal into a query string
 * @param object obj
 * @returns string
 */
const objectToQueryString = (obj) => {
  let queryString = [];
  for(let prop in obj) {
    if (!obj.hasOwnProperty(prop)) continue;
    queryString.push(prop + '=' + obj[prop]);
  }
  return '?' + queryString.join('&');
};

/**
 * Merges two object literals together (non-recursively).
 *
 * @param object obj - The object to merge into.
 * @param object obj2 - The object to merge from.
 * @return object
 */
const mergeObj = (obj, obj2) => {
  for (let key in obj2) {
    if (obj2.hasOwnProperty(key)) {
      obj[key] = obj2[key];
    }
  }
  return obj;
};

/**
 * Merges settings from two table maps into an object literal.
 * @returns object
 */
const mergeSettings = (fromVar, tableKey) => {
  const defaults = getType(data[fromVar]) === 'object' ? data[fromVar] : {};
  const overrides = data[tableKey] && data[tableKey].length ? makeTableMap(data[tableKey], 'name', 'value') : {};
  return mergeObj(defaults, overrides);
};

const commands = {
  logEvent: function(eventName, params) {
    logToConsole('[Prototype Firebase + GTM Interface] | ', 'commands logEvent: ', arguments);
    callInWindow('firebaseAnalyticsInterface.logEvent', eventName, params);
  },
  setUserId: function(userId) {
    logToConsole('[Prototype Firebase + GTM Interface] | ', 'commands setUserId: ', arguments);
    callInWindow('firebaseAnalyticsInterface.setUserId', userId);
  },
  setUserProperty: function(name, value) {
    logToConsole('[Prototype Firebase + GTM Interface] | ', 'commands setUserProperty: ', arguments);
    callInWindow('firebaseAnalyticsInterface.setUserProperty', name, value);
  },
  setDefaultEventParameters: function(params) {
    logToConsole('[Prototype Firebase + GTM Interface] | ', 'commands setDefaultEventParameters: ', arguments);
    callInWindow('firebaseAnalyticsInterface.setDefaultEventParameters', params);
  },
  setAnalyticsCollectionEnabled: function() {},
  resetAnalyticsData: function() {},
  getAppInstanceId: function() {},
  getSessionId: function() {},
  setConsent: function() {}
};

const parameters = mergeSettings('parametersFromVariable', 'parametersList');
logToConsole('[Prototype Firebase + GTM Interface] | ', 'parameters: ', parameters);

const userProperties = mergeSettings('userPropertiesFromVariable', 'userPropertiesList');
logToConsole('[Prototype Firebase + GTM Interface] | ', 'userProperties: ', userProperties);

const command = data.command;
switch(command) {
  case 'logEvent':
    if (getType(parameters.user_properties) === 'object') {
      const userProperties = parameters.user_properties;
      Object.delete(parameters, 'user_properties');
      Object.entries(userProperties).forEach((entry) => commands.setUserProperty(entry[0], entry[1]));
    }
    commands[command](data.eventName, parameters);
    break;
  case 'setUserId':
    commands[command](data.userId);
    break;
  case 'setUserProperty':
    if (getType(userProperties) === 'object') {
      Object.entries(userProperties).forEach((entry) => commands.setUserProperty(entry[0], entry[1]));
    }
    break;
  case 'setDefaultEventParameters':
    if (getType(parameters.user_properties) === 'object') {
      const userProperties = parameters.user_properties;
      Object.delete(parameters, 'user_properties');
      Object.entries(userProperties).forEach((entry) => commands.setUserProperty(entry[0], entry[1]));
    }
    commands[command](parameters);
    break;
}

data.gtmOnSuccess();


___WEB_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "access_globals",
        "versionId": "1"
      },
      "param": [
        {
          "key": "keys",
          "value": {
            "type": 2,
            "listItem": [
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "firebaseAnalyticsInterface"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "firebaseAnalyticsInterface.logEvent"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "firebaseAnalyticsInterface.setUserProperty"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "firebaseAnalyticsInterface.setDefaultEventParameters"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "firebaseAnalyticsInterface.setUserId"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "firebaseAnalyticsInterface.setAnalyticsCollectionEnabled"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "firebaseAnalyticsInterface.resetAnalyticsData"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "firebaseAnalyticsInterface.getAppInstanceId"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "firebaseAnalyticsInterface.getSessionId"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              },
              {
                "type": 3,
                "mapKey": [
                  {
                    "type": 1,
                    "string": "key"
                  },
                  {
                    "type": 1,
                    "string": "read"
                  },
                  {
                    "type": 1,
                    "string": "write"
                  },
                  {
                    "type": 1,
                    "string": "execute"
                  }
                ],
                "mapValue": [
                  {
                    "type": 1,
                    "string": "firebaseAnalyticsInterface.setConsent"
                  },
                  {
                    "type": 8,
                    "boolean": true
                  },
                  {
                    "type": 8,
                    "boolean": false
                  },
                  {
                    "type": 8,
                    "boolean": true
                  }
                ]
              }
            ]
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []


___NOTES___

Created on 11/23/2023, 7:51:37 AM


