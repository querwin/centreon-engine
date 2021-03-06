##
## Copyright 2011-2013,2015 Merethis
##
## This file is part of Centreon Engine.
##
## Centreon Engine is free software: you can redistribute it and/or
## modify it under the terms of the GNU General Public License version 2
## as published by the Free Software Foundation.
##
## Centreon Engine is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
## General Public License for more details.
##
## You should have received a copy of the GNU General Public License
## along with Centreon Engine. If not, see
## <http://www.gnu.org/licenses/>.
##

# Set directories.
set(SRC_DIR "${SRC_DIR}/objects")
set(INC_DIR "${INC_DIR}/com/centreon/engine/objects")

# Set files.
set(
  FILES
  ${FILES}

  # Sources.
  "${SRC_DIR}/command.cc"
  "${SRC_DIR}/commandsmember.cc"
  "${SRC_DIR}/customvariablesmember.cc"
  "${SRC_DIR}/daterange.cc"
  "${SRC_DIR}/host.cc"
  "${SRC_DIR}/hostdependency.cc"
  "${SRC_DIR}/hostsmember.cc"
  "${SRC_DIR}/objectlist.cc"
  "${SRC_DIR}/service.cc"
  "${SRC_DIR}/servicedependency.cc"
  "${SRC_DIR}/servicesmember.cc"
  "${SRC_DIR}/timeperiod.cc"
  "${SRC_DIR}/timeperiodexclusion.cc"
  "${SRC_DIR}/timerange.cc"

  # Headers.
  "${INC_DIR}/command.hh"
  "${INC_DIR}/commandsmember.hh"
  "${INC_DIR}/customvariable.hh"
  "${INC_DIR}/customvariablesmember.hh"
  "${INC_DIR}/daterange.hh"
  "${INC_DIR}/host.hh"
  "${INC_DIR}/hostdependency.hh"
  "${INC_DIR}/hostsmember.hh"
  "${INC_DIR}/objectlist.hh"
  "${INC_DIR}/service.hh"
  "${INC_DIR}/servicedependency.hh"
  "${INC_DIR}/servicesmember.hh"
  "${INC_DIR}/timeperiod.hh"
  "${INC_DIR}/timeperiodexclusion.hh"
  "${INC_DIR}/timerange.hh"
  "${INC_DIR}/tool.hh"

  PARENT_SCOPE
)
