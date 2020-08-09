/* eslint-disable react/no-unescaped-entities */
import React, { useState } from 'react';

const IconInfo = () =>   <svg width="1em" height="1em" viewBox="0 0 16 16" className="bi bi-info-circle-fill" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
    <path fillRule="evenodd" d="M8 16A8 8 0 1 0 8 0a8 8 0 0 0 0 16zm.93-9.412l-2.29.287-.082.38.45.083c.294.07.352.176.288.469l-.738 3.468c-.194.897.105 1.319.808 1.319.545 0 1.178-.252 1.465-.598l.088-.416c-.2.176-.492.246-.686.246-.275 0-.375-.193-.304-.533L8.93 6.588zM8 5.5a1 1 0 1 0 0-2 1 1 0 0 0 0 2z"/>
</svg>;


const InstructionBox = () => {

    const [isOpen, setIsOpen] = useState(true);

    return isOpen ? <div 
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
                  The <strong>A Button</strong> corresponds to the <strong>X Key</strong> on the keyboard.
                        </li>
                        <li>
                  You can pause using the <strong>Start Button</strong> or using the <strong>Enter Key</strong> on the keyboard.
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
        </div>
    </div> : 
        <div 
            className="instruction-box__closed"
            onClick={() => setIsOpen(true)}
        >
            <IconInfo />
        </div> ;
};

export default InstructionBox;