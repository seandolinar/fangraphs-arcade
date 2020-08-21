import React, { Component } from "react";
import { Button, Progress } from "reactstrap";
import { Link } from "react-router-dom";

import config from "./config";
import ControlsModal from "./ControlsModal";
import Emulator from "./Emulator";
import Screen from "./Screen";

import RomLibrary from "./RomLibrary";
import { loadBinary } from "./utils";

import VirtualGamePadController from './VirtualGamePadController.js';
import InstructionBox from './InstructionBox.js';

import "./RunPage.scss";

// clip path for TV screen shape
const clipPath = <svg width="0" height="0">
    <defs>
        <clipPath id="svgPath" clipPathUnits="objectBoundingBox">
        <path d="M0.022,0.033c0.147,-0.018 0.306,-0.028 0.472,-0.028c0.169,0 0.331,0.01 0.482,0.029c0.014,0.149 0.022,0.307 0.022,0.471c0,0.161 -0.008,0.317 -0.021,0.464c-0.151,0.019 -0.314,0.03 -0.483,0.03c-0.166,0 -0.325,-0.01 -0.473,-0.029c-0.014,-0.147 -0.021,-0.303 -0.021,-0.465c0,-0.164 0.008,-0.323 0.022,-0.472Z"/>        </clipPath>
    </defs>
</svg>

const iconArrow =  <svg width="1em" height="1em" viewBox="0 0 16 16" className="bi bi-arrow-up-square-fill" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
  <path fillRule="evenodd" d="M2 0a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2H2zm3.354 8.354a.5.5 0 1 1-.708-.708l3-3a.5.5 0 0 1 .708 0l3 3a.5.5 0 0 1-.708.708L8.5 6.207V11a.5.5 0 0 1-1 0V6.207L5.354 8.354z"/>
</svg>

/*
 * The UI for the emulator. Also responsible for loading ROM from URL or file.
 */
class RunPage extends Component {
  constructor(props) {
    super(props);
    this.state = {
      badClicks: 0,
      romName: null,
      romData: null,
      running: false,
      paused: false,
      controlsModalOpen: false,
      loading: true,
      loadedPercent: 3,
      error: null,
      isPowered: false
    };
  }

  render() {
    return (
      <div className="RunPage">
        {this.state.error ? (
          this.state.error
        ) : (
          <div className="tv">
          <div
            className="screen-container"
            ref={el => {
              this.screenContainer = el;
            }}
          >
            {clipPath}
            {this.state.loading ? (
              <Progress
                value={this.state.loadedPercent}
                style={{
                  position: "absolute",
                  width: "70%",
                  left: "15%",
                  top: "48%"
                }}
              />
            ) : this.state.romData && this.state.isPowered  ? 
              // container div determines the screen size
              (<Emulator
                romData={this.state.romData}
                paused={this.state.paused}
                ref={emulator => {
                  this.emulator = emulator;
                }}
              />
            ) : <Screen className="power-off" /> }

            {/* TODO: lift keyboard and gamepad state up */}
          </div>
          <div className={`tv__side-panel ${!!this.state.isPowered ? 'power-on' : 'power-off'}`}>
            <div className="tv__control">
              <div 
                className="tv__control__power"
                onClick={() => this.setState({isPowered: !this.state.isPowered})
                }>
                  Power
                  <div className="tv__control__power-indicator"></div>
                  { !this.state.isPowered && this.state.badClicks > 5 && <div className="tv__control__power-indicator__arrow">
                    <div>
                      { iconArrow }
                    </div>
                    <div>
                    Click here to start!
                    </div>
                    </div>}
                </div>
                <div className="tv__control__channel">
                  03
                </div>
            </div>
            <div className="tv__speaker">
              <div></div>
              {!!this.state.isPowered && <div
                className="controls-modal__closed"
                onClick={this.toggleControlsModal}
              >
                <img className="controller-icon" src="../img/keyboard.png" alt="keyboard" />
              </div>}
              <InstructionBox />
            </div>
          </div>
          {this.state.controlsModalOpen && !!this.emulator && (
              <ControlsModal
                isOpen={this.state.controlsModalOpen}
                toggle={this.toggleControlsModal}
                keys={this.emulator.keyboardController.keys}
                setKeys={this.emulator.keyboardController.setKeys}
                promptButton={this.emulator.gamepadController.promptButton}
                gamepadConfig={this.emulator.gamepadController.gamepadConfig}
                setGamepadConfig={
                  this.emulator.gamepadController.setGamepadConfig
                }
              />
            ) } 
          </div>
        )}
        <VirtualGamePadController 
          onButtonDown={(a, b) => !!this.emulator && this.emulator.nes.buttonDown(a, b)}
          onButtonUp={(a, b) => !!this.emulator && this.emulator.nes.buttonUp(a, b) }
        />
      </div>
    );
  }

  componentDidMount() {
    window.addEventListener("resize", this.layout);
    window.addEventListener('click', this.handleHint);
    this.layout();
    this.load();
  }

//   if (!!this.state.isPowered) {
//     window.removeEventListener('click', handleHint);
// }

  componentWillUnmount() {
    window.removeEventListener("resize", this.layout);
    if (this.currentRequest) {
      this.currentRequest.abort();
    }
  }

  handleHint = () => {
    this.setState({ badClicks: this.state.badClicks + 1 })
    if (!!this.state.isPowered) {
      window.removeEventListener('click', this.handleHint)
      this.setState({ badClicks: -1 })
    }
  };

  load = () => {
    if (this.props.match.params.slug) {
      const slug = this.props.match.params.slug;
      const isLocalROM = /^local-/.test(slug);
      const romHash = slug.split("-")[1];
      const romInfo = isLocalROM
        ? RomLibrary.getRomInfoByHash(romHash)
        : config.ROMS[slug];

      if (!romInfo) {
        this.setState({ error: `No such ROM: ${slug}` });
        return;
      }

      if (isLocalROM) {
        this.setState({ romName: romInfo.name });
        const localROMData = localStorage.getItem("blob-" + romHash);
        this.handleLoaded(localROMData);
      } else {
        this.setState({ romName: romInfo.description });
        this.currentRequest = loadBinary(
          romInfo.url,
          (err, data) => {
            if (err) {
              this.setState({ error: `Error loading ROM: ${err.message}` });
            } else {
              this.handleLoaded(data);
            }
          },
          this.handleProgress
        );
      }
    } else if (this.props.location.state && this.props.location.state.file) {
      let reader = new FileReader();
      reader.readAsBinaryString(this.props.location.state.file);
      reader.onload = e => {
        this.currentRequest = null;
        this.handleLoaded(reader.result);
      };
    } else {
      this.setState({ error: "No ROM provided" });
    }
  };

  handleProgress = e => {
    if (e.lengthComputable) {
      this.setState({ loadedPercent: (e.loaded / e.total) * 100 });
    }
  };

  handleLoaded = data => {
    this.setState({ running: true, loading: false, romData: data });
  };

  handlePauseResume = () => {
    this.setState({ paused: !this.state.paused });
  };

  layout = () => {
    let navbarHeight = 0 // parseFloat(window.getComputedStyle(this.navbar).height);

    this.screenContainer.style.height = `${window.innerHeight -
      navbarHeight}px`;

    if (window.innerWidth <= 430) {
      this.screenContainer.style.height = `${this.screenContainer.getBoundingClientRect().width * .95}px`;
    }
    else {
      this.screenContainer.style.height = `${this.screenContainer.getBoundingClientRect().width * .75}px`;
    }


    if (this.emulator) {
      this.emulator.fitInParent();
    }

    if (this.screen) {
      console.log(this.screen)
      this.screen.fitInParent();
    }
  };

  toggleControlsModal = () => {
    this.setState({ controlsModalOpen: !this.state.controlsModalOpen });
  };
}

export default RunPage;
