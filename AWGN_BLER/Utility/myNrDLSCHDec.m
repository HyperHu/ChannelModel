classdef myNrDLSCHDec < nrDLSCHDecoder
    %MYNRDLSCHDEC Summary of this class goes here
    %   Detailed explanation goes here
    properties (Access=private)
        % Copies of public properties, scalar expanded, if necessary.
        pTargetCodeRate;
        pTransportBlockLength;
    end
    
    methods(Access = protected)

        function num = getNumInputsImpl(obj)
            % Number of Inputs based on property for varargin in step
            num = 4+double(obj.MultipleHARQProcesses);
        end

        function setupImpl(obj)
            setPrivateProperties(obj);
        end

        function [rxBits,blkCRCErr,cbCRCErr] = stepImpl(obj,rxSoftBits,modulation, ...
                nlayers,rv,varargin)
        % Supported syntaxes:
        %   [rxBits,blkCRCErr] = step(obj,rxSoftBits,modulation,nlayers,rv)
        %   [rxBits,blkCRCErr] = step(obj,rxSoftBits,modulation,nlayers,rv,harqID)

            narginchk(5,6)
            fcnName = [class(obj) '/step'];

            % Validate inputs
            validateattributes(nlayers, {'numeric'}, ...
                {'scalar','integer','<=',8,'>=',1},fcnName,'NLAYERS');
            if nlayers>4  % Key check
                is2CW = true;
                nl1 = floor(nlayers/2);
                nl2 = ceil(nlayers/2);
            else
                is2CW = false;
                nl1 = nlayers;
            end

            modlist = {'QPSK','16QAM','64QAM','256QAM'};
            if iscell(modulation)
                modLen = length(modulation);
                validateattributes(modLen,{'numeric'}, ...
                    {'scalar','>',0,'<',3},fcnName, ...
                    'Length of MODULATION specified as a cell');

                modSch = cell(1,modLen);
                for idx = 1:modLen
                    modSch{idx} = validatestring(modulation{idx},modlist, ...
                        fcnName,'MODULATION');
                end
            else
                modSch = validatestring(modulation,modlist,fcnName,'MODULATION');
            end
            % Scalar expand, if necessary
            if iscell(modSch)
                if is2CW && length(modSch)==1
                    modScheme = {modSch{1},modSch{1}};
                else
                    modScheme = modSch;
                end
            else
                if is2CW
                    modScheme = {modSch,modSch};
                else
                    modScheme = {modSch};
                end
            end

            % vector RV value
            coder.internal.errorIf( is2CW && length(rv)~=2, ...
                'nr5g:nrDLSCH:InvalidRVLength');
            if is2CW
                % vector RV value
                validateattributes(rv,{'numeric'}, ...
                    {'integer','>=',0,'<=',3},fcnName,'RV')
            else
                % Check RV input is a scalar
                nr5g.internal.validateParameters('RV',rv,fcnName);
            end

            if nargin == 5 % step(obj,rxSoftBits,modulation,nlayers,rv)
                harqID = 0;
            else    % step(obj,rxSoftBits,modulation,nlayers,rv,harqID)
                harqID = varargin{1};
                nr5g.internal.validateParameters('HARQID',harqID,fcnName);
            end

            % Allows both cell and column as input. Cross-checks with
            % is2CW and handles empties as inputs
            if iscell(rxSoftBits)
                if length(rxSoftBits)==2
                    coder.internal.errorIf(~is2CW,'nr5g:nrDLSCH:InvalidSCWInput');

                    rxSoftBits1 = rxSoftBits{1};
                    rxSoftBits2 = rxSoftBits{2};

                    if isempty(rxSoftBits1) && isempty(rxSoftBits2)
                        rxBits1 = zeros(0,1,'int8');
                        rxBits2 = zeros(0,1,'int8');
                        rxBits = {rxBits1, rxBits2};
                        blkCRCErr = false(1,2);  % no error
                    else
                        validateattributes(rxSoftBits{1},{'double','single'}, ...
                            {'real','column'},fcnName,'Codeword 1');
                        validateattributes(rxSoftBits{2},{'double','single'}, ...
                            {'real','column'},fcnName,'Codeword 2');

                        % Process first codeword
                        [rxBits1,blkCRCErr1,cbCRCErr1] = dlschDecode(obj,rxSoftBits1, ...
                            modScheme{1},nl1,rv(1),harqID,1);
                        % Process second codeword
                        [rxBits2,blkCRCErr2,cbCRCErr2] = dlschDecode(obj,rxSoftBits2, ...
                            modScheme{2},nl2,rv(2),harqID,2);

                        rxBits = {rxBits1,rxBits2};
                        blkCRCErr = [blkCRCErr1,blkCRCErr2];
                        cbCRCErr = [cbCRCErr1; cbCRCErr2];
                    end

                elseif length(rxSoftBits)==1
                    coder.internal.errorIf(is2CW,'nr5g:nrDLSCH:InvalidMCWInput');

                    rxSoftBits1 = rxSoftBits{1};
                    if isempty(rxSoftBits1)
                        rxBits = zeros(size(rxSoftBits1),'int8');
                        blkCRCErr = false;  % no error
                    else
                        validateattributes(rxSoftBits1,{'double','single'}, ...
                            {'real','column'},fcnName,'Codeword 1');

                        % Process first codeword
                        [rxBits,blkCRCErr,cbCRCErr] = dlschDecode(obj,rxSoftBits1, ...
                            modScheme{1},nl1,rv(1),harqID,1);
                    end
                    % output is a column vector, not a cell
                else
                    coder.internal.errorIf(1,'nr5g:nrDLSCH:InvalidRxInputCellLength');
                end
            else
                coder.internal.errorIf(is2CW,'nr5g:nrDLSCH:InvalidMCWInput');

                if isempty(rxSoftBits)
                    rxBits = zeros(size(rxSoftBits),'int8');
                    blkCRCErr = false;  % no error
                else
                    validateattributes(rxSoftBits,{'double','single'}, ...
                        {'real','column'},fcnName,'Codeword 1');

                    % Process first codeword
                    [rxBits,blkCRCErr,cbCRCErr] = dlschDecode(obj,rxSoftBits, ...
                        modScheme{1},nl1,rv(1),harqID,1);
                end
            end

        end

        function [rxBits,blkCRCErr,cbCRCErr] = dlschDecode(obj,rxSoftBits, ...
                modScheme,nlayers,rv,harqID,cwIdx)
            % Decode DLSCH per codeword

            targetCodeRate = obj.pTargetCodeRate(cwIdx);
            trBlkLen = obj.pTransportBlockLength(cwIdx);
            info = nrDLSCHInfo(trBlkLen,targetCodeRate);

            % Rate recovery
            ncb = info.C;
            raterecovered = nrRateRecoverLDPC(rxSoftBits,trBlkLen, ...
                targetCodeRate,rv,modScheme,nlayers,ncb, ...
                obj.LimitedBufferSize);

            % Combining
            if isequal(size(obj.pCWSoftBuffer{harqID+1}{cwIdx}),[info.N,ncb])
                raterecoveredD = double(raterecovered) + obj.pCWSoftBuffer{harqID+1}{cwIdx};
            else
                raterecoveredD = double(raterecovered);
            end

            % LDPC decoding: set to early terminate, within max iterations
            decoded = nrLDPCDecode(raterecoveredD,info.BGN,obj.MaximumLDPCIterationCount);

            % Code block desegmentation and code block CRC decoding
            [desegmented, cbErr] = nrCodeBlockDesegmentLDPC(decoded,info.BGN,trBlkLen+info.L);

            % Transport block CRC decoding
            [rxBits,blkErr] = nrCRCDecode(desegmented,info.CRC);

            % Logic to reset in case no more RVs are available is not here.
            % Calling code would reset this object in that case.
            errflg = (blkErr ~= 0); % errored
            if errflg
                obj.pCWSoftBuffer{harqID+1}{cwIdx} = raterecoveredD;
            else
                % Flush soft buffer on CRC pass
                obj.pCWSoftBuffer{harqID+1}{cwIdx} = [];
            end
            blkCRCErr = errflg;
            cbCRCErr = (cbErr ~= 0);
        end

        function resetImpl(obj)
            % Initialize / reset discrete-state properties
            for cwIdx = 1:2
                info = nrDLSCHInfo(obj.pTransportBlockLength(cwIdx), ...
                    obj.pTargetCodeRate(cwIdx));
                obj.pCWSoftBuffer{1}{cwIdx} = zeros(info.N,info.C);
                if obj.MultipleHARQProcesses
                    for harqIdx = 2:16
                        obj.pCWSoftBuffer{harqIdx}{cwIdx} = zeros(info.N,info.C);
                    end
                end
            end
        end

        function processTunedPropertiesImpl(obj)
            % Perform calculations if tunable properties change while
            % system is running
            setPrivateProperties(obj);
        end

        function setPrivateProperties(obj)
            % scalar expand properties, if needed.
            if isscalar(obj.TargetCodeRate)
                obj.pTargetCodeRate = obj.TargetCodeRate.*ones(1,2);
            else
                obj.pTargetCodeRate = obj.TargetCodeRate;
            end

            if isscalar(obj.TransportBlockLength)
                obj.pTransportBlockLength = obj.TransportBlockLength.*ones(1,2);
            else
                obj.pTransportBlockLength = obj.TransportBlockLength;
            end
        end

        function s = saveObjectImpl(obj)
            s = saveObjectImpl@matlab.System(obj);
            if isLocked(obj)
                s.pCWSoftBuffer         = obj.pCWSoftBuffer;
                s.pTargetCodeRate       = obj.pTargetCodeRate;
                s.pTransportBlockLength = obj.pTransportBlockLength;
            end
        end

        function loadObjectImpl(obj,s,wasLocked)
            if wasLocked
                obj.pCWSoftBuffer         = s.pCWSoftBuffer;
                obj.pTargetCodeRate       = s.pTargetCodeRate;
                obj.pTransportBlockLength = s.pTransportBlockLength;
            end
            % Call the base class method
            loadObjectImpl@matlab.System(obj,s);
        end
       
    end
end

