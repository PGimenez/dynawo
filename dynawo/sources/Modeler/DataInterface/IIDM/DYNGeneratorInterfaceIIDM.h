//
// Copyright (c) 2015-2019, RTE (http://www.rte-france.com)
// See AUTHORS.txt
// All rights reserved.
// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, you can obtain one at http://mozilla.org/MPL/2.0/.
// SPDX-License-Identifier: MPL-2.0
//
// This file is part of Dynawo, an hybrid C++/Modelica open source time domain
// simulation tool for power systems.
//

//======================================================================
/**
 * @file  DataInterface/IIDM/DYNGeneratorInterfaceIIDM.h
 *
 * @brief Generator data interface : header file for IIDM interface
 *
 */
//======================================================================
#ifndef MODELER_DATAINTERFACE_IIDM_DYNGENERATORINTERFACEIIDM_H_
#define MODELER_DATAINTERFACE_IIDM_DYNGENERATORINTERFACEIIDM_H_

#include <boost/shared_ptr.hpp>
#include <IIDM/extensions/generatorActivePowerControl/GeneratorActivePowerControl.h>

#include "DYNGeneratorInterface.h"
#include "DYNInjectorInterfaceIIDM.h"

namespace IIDM {
class Generator;
}

namespace DYN {

/**
 * class GeneratorInterfaceIIDM
 */
class GeneratorInterfaceIIDM : public GeneratorInterface, public InjectorInterfaceIIDM<IIDM::Generator> {
 public:
  /**
   * @brief defines the index of each state variable
   */
  typedef enum {
    VAR_P = 0,
    VAR_Q,
    VAR_STATE
  } indexVar_t;

 public:
  /**
   * @brief Destructor
   */
  ~GeneratorInterfaceIIDM();

  /**
   * @brief Constructor
   * @param generator generator's iidm instance
   */
  explicit GeneratorInterfaceIIDM(IIDM::Generator& generator);

  /**
   * @copydoc ComponentInterface::exportStateVariablesUnitComponent()
   */
  void exportStateVariablesUnitComponent();

  /**
   * @copydoc ComponentInterface::importStaticParameters()
   */
  void importStaticParameters();

  /**
   * @copydoc ComponentInterface::isConnected()
   */
  bool isConnected() const;

  /**
   * @copydoc GeneratorInterface::setBusInterface(const boost::shared_ptr<BusInterface>& busInterface)
   */
  void setBusInterface(const boost::shared_ptr<BusInterface>& busInterface);

  /**
   * @copydoc GeneratorInterface::setVoltageLevelInterface(const boost::shared_ptr<VoltageLevelInterface>& voltageLevelInterface)
   */
  void setVoltageLevelInterface(const boost::shared_ptr<VoltageLevelInterface>& voltageLevelInterface);

  /**
   * @copydoc GeneratorInterface::getBusInterface() const
   */
  boost::shared_ptr<BusInterface> getBusInterface() const;

  /**
   * @copydoc GeneratorInterface::getInitialConnected()
   */
  bool getInitialConnected();

  /**
   * @copydoc GeneratorInterface::getP()
   */
  double getP();

  /**
   * @copydoc GeneratorInterface::getPMin()
   */
  double getPMin();

  /**
   * @copydoc GeneratorInterface::getPMax()
   */
  double getPMax();

  /**
   * @copydoc GeneratorInterface::getTargetP()
   */
  double getTargetP();

  /**
   * @copydoc GeneratorInterface::getQ()
   */
  double getQ();

  /**
   * @copydoc GeneratorInterface::getQMax()
   */
  double getQMax();

  /**
   * @copydoc GeneratorInterface::getQNom()
   */
  double getQNom();

  /**
   * @copydoc GeneratorInterface::getQMin()
   */
  double getQMin();

  /**
   * @copydoc GeneratorInterface::getTargetQ()
   */
  double getTargetQ();

  /**
   * @copydoc GeneratorInterface::getTargetV()
   */
  double getTargetV();

  /**
   * @copydoc GeneratorInterface::getID() const
   */
  std::string getID() const;

  /**
   * @copydoc ComponentInterface::getComponentVarIndex()
   */
  int getComponentVarIndex(const std::string& varName) const;

  /**
   * @copydoc GeneratorInterface::getReactiveCurvesPoints() const
   */
  std::vector<ReactiveCurvePoint> getReactiveCurvesPoints() const;

  /**
   * @copydoc GeneratorInterface::isVoltageRegulationOn() const
   */
  bool isVoltageRegulationOn() const;

  /**
   * @copydoc GeneratorInterface::hasActivePowerControl() const
   */
  bool hasActivePowerControl() const;

  /**
   * @copydoc GeneratorInterface::isParticipating() const
   */
  bool isParticipating() const;

  /**
   * @copydoc GeneratorInterface::getActivePowerControlDroop() const
   */
  double getActivePowerControlDroop() const;

  /**
   * @copydoc GeneratorInterface::hasCoordinatedReactiveControl() const
   */
  bool hasCoordinatedReactiveControl() const;

  /**
   * @copydoc GeneratorInterface::getCoordinatedReactiveControlPercentage() const
   */
  double getCoordinatedReactiveControlPercentage() const;

  /**
   * @copydoc GeneratorInterface::getDroop() const
   */
  boost::optional<double> getDroop() const {
    // not implemented
    return boost::none;
  }

  /**
   * @copydoc GeneratorInterface::isParticipate() const
   */
  boost::optional<bool> isParticipate() const {
    // not implemented
    return boost::none;
  }

  /**
   * @brief Getter for the generator' country
   * @return the generator country
   */
  inline const std::string& getCountry() const {
    return country_;
  }

  /**
   * @brief Setter for the generator' country
   * @param country generator country
   */
  inline void setCountry(const std::string& country) {
    country_ = country;
  }

 private:
  IIDM::Generator& generatorIIDM_;  ///< reference to the iidm generator instance
  std::string country_;  ///< country of the generator
  IIDM::extensions::generatoractivepowercontrol::GeneratorActivePowerControl * activePowerControl_;  ///< pointer to ActivePowerControl extension
};
}  // namespace DYN

#endif  // MODELER_DATAINTERFACE_IIDM_DYNGENERATORINTERFACEIIDM_H_
