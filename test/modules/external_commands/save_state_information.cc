/*
** Copyright 2011-2013,2015 Merethis
**
** This file is part of Centreon Engine.
**
** Centreon Engine is free software: you can redistribute it and/or
** modify it under the terms of the GNU General Public License version 2
** as published by the Free Software Foundation.
**
** Centreon Engine is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
** General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with Centreon Engine. If not, see
** <http://www.gnu.org/licenses/>.
*/

#include <exception>
#include "com/centreon/engine/broker.hh"
#include "com/centreon/engine/error.hh"
#include "com/centreon/engine/modules/external_commands/commands.hh"
#include "com/centreon/engine/globals.hh"
#include "com/centreon/logging/engine.hh"
#include "com/centreon/engine/nebstructs.hh"
#include "test/unittest.hh"

using namespace com::centreon::engine;

/**
 *  callback used by broker.
 *
 *  @param[in] callback_type The callback type send by the broker.
 *  @param[in] data          The nebstruct external command send by the broker.
 *
 *  @return the last callback_type recve by the callback.
 */
static int broker_callback(int callback_type, void* data) {
  static int last_callback_type = -1;
  int ret = last_callback_type;

  nebstruct_external_command_data* neb_data
    = static_cast<nebstruct_external_command_data*>(data);
  if (callback_type != -1)
    last_callback_type = neb_data->type;
  else
    last_callback_type = -1;
  return (ret);
}

/**
 *  Run save_state_information test.
 */
static int check_save_state_information(int argc, char** argv) {
  (void)argc;
  (void)argv;

  // register broker callback to catch event.
  config->event_broker_options(BROKER_RETENTION_DATA);
  void* module_id = reinterpret_cast<void*>(0x4242);
  neb_register_callback(NEBCALLBACK_RETENTION_DATA,
                        module_id,
                        0,
                        &broker_callback);

  char const* cmd("[1317196300] SAVE_STATE_INFORMATION");
  process_external_command(cmd);

  if (broker_callback(-1, NULL) != NEBTYPE_RETENTIONDATA_ENDSAVE)
    throw (engine_error() << "save_state_information failed.");

  // release callback.
  neb_deregister_module_callbacks(module_id);

  return (0);
}

/**
 *  Init unit test.
 */
int main(int argc, char** argv) {
  unittest utest(argc, argv, &check_save_state_information);
  return (utest.run());
}
