/* eslint-disable react/no-unescaped-entities */
import React, { useState } from 'react';
import { IconInfo } from './svg';

const InstructionBox = () => {

    const [isOpen, setIsOpen] = useState(true);

    return <>{ isOpen && <div 
        className={`instruction-box`}
        onClick={() => setIsOpen(false)}
    >
        <div className="instruction-box__copy">
          Instructions
            <IconInfo />
            <ul>
                <li>
              Click on TV's power button.
                </li>
                <li>
              Keyboard Controls
                    <ul>
                        <li>
                  Arrow keys are your direction pad or joystick.
                        </li>
                        <li>
                  The <strong>A Button</strong> corresponds to the <strong>A Key</strong> on the keyboard.
                        </li>
                        <li>
                  You can pause using the <strong>Start Button</strong> or
                   using the <strong>Enter Key</strong> on the keyboard.
                        </li>
                    </ul>
                </li>
                <li>
              Game Play
                    <ul>
                        <li>You get three outs per inning.</li>
                        <li>Press the <strong>A Button</strong> or <strong>A Key</strong> to continue after an out.</li>
                        <li>Like baseball this game doesn't end.</li>
                    </ul>
                </li>
            </ul>
        </div>
    </div>}
    <div 
        className="instruction-box__closed"
        onClick={() => setIsOpen(true)}
    >
        <IconInfo />
    </div>
    </>;
};

export default InstructionBox;