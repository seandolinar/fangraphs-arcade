import React from "react";

import "./VirtualGamePadButton.css";

const VirtualGamePadButton = ({
    buttonType,
    keyCode,
}) => {

    const onClick = () => {
        console.log('click')
        document.dispatchEvent(new KeyboardEvent('keydown',{ 'keyCode': 88 }));
        document.dispatchEvent(new KeyboardEvent('keydown',{ 'keyCode': 88 }));
    };

    

    return <div className="virtual-game-pad__button"
        onClick={onClick}
    >
        hi
    </div>;
};

export default VirtualGamePadButton;

