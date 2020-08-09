import React from "react";
import { includes } from 'lodash';
import { Controller } from "jsnes";

import "./VirtualGamePadButton.scss";

const VirtualGamePadButton = ({
    button,
    className='',
    controller=1,
    onButtonDown,
    onButtonUp
}) => {

    return <div className={`virtual-game-pad__button__wrapper ${className}`}>
        <div className="virtual-game-pad__button"
            data-button={button}
            onMouseDown={() => onButtonDown(controller, button)}
            onMouseUp={() => onButtonUp(controller, button)}
            onTouchStart={() => onButtonDown(controller, button)}
            onTouchEnd={() => onButtonUp(controller, button)}
        >
            { includes([
                Controller.BUTTON_LEFT, 
                Controller.BUTTON_RIGHT,
                Controller.BUTTON_UP,
                Controller.BUTTON_DOWN
            ], button) && <div className={`button-dpad__arrow d-${button}`}></div>}
        </div>
    </div>;
};

export default VirtualGamePadButton;

