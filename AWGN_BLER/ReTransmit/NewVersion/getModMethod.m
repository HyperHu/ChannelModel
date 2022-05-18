function modMethod = getModMethod(theQm)
%#codegen
switch theQm
    case int32(8)
        modMethod = '256QAM';
    case int32(6)
        modMethod = '64QAM';
      case int32(4)
        modMethod = '16QAM';
        case int32(2)
        modMethod = 'QPSK';
    otherwise
        modMethod = 'pi/2-BPSK';
end
end

