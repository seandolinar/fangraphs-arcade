/* eslint-disable react/no-unescaped-entities */
import React, { useState } from 'react';



const InstructionBox = () => {

    const [isOpen, setIsOpen] = useState(true);

    return isOpen ? <div className="instruction-box" onClick={() => setIsOpen(false)}>
          Instructions
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
                  The <strong>A Button</strong> corresponds to the <strong>X Key</strong> on the keyboard.
                    </li>
                    <li>
                  You can pause using the 
                        <strong>Start Button</strong> or using the 
                        <strong>Enter Key</strong> on the keyboard.
                    </li>
                </ul>
            </li>
            <li>
              Game Play
                <ul>
                    <li>You get three outs per inning.</li>
                    <li>Press the "A Button" or "X Key" to continue after an out.</li>
                    <li>Like baseball this game doesn't end.</li>
                </ul>
            </li>
        </ul>
    </div> : <div>closed</div> ;
};

export default InstructionBox;