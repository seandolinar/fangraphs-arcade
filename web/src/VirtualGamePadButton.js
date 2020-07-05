import React from "react";

import "./VirtualGamePadButton.css";

const VirtualGamePadButton = ({
    button,
    className='',
    controller=1,
    onButtonDown,
    onButtonUp
}) => {

    return <div className={`virtual-game-pad__button__wrapper ${className}`}>
        <div className="virtual-game-pad__button"
            onMouseDown={() => onButtonDown(controller, button)}
            onMouseUp={() => onButtonUp(controller, button)}
        >
        </div>
    </div>;
};

export default VirtualGamePadButton;

