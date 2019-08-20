require 'json';

module Schema

    # Request Handler is the base class to handle all requests
    # and offers a standard set of methods that will be used to parse
    # the response from the client
    class ReqHandler

        def initialize(_hParams)
            @hParams = _hParams;
            @bDebug  = @hParams['debug'];
        end

        # make sure that the given list of parameters have been received
        def assure(*_aParams)
            aMissing = [];
            _aParams.each { |sParam|
                sValue = @hParams[sParam];
                aMissing << sParam if (sValue.to_s == '');
            }
            return error("Missing params: #{aMissing.join(', ')}") unless aMissing.empty?;

            yield;
        end

        # return a success json response
        def success(_oData)
            return { :success => true, :data => _oData }.to_json;
        end

        # return a success json response
        def success_tree(_aChildren)
            return { :success => true, :children => _aChildren }.to_json;
        end

        # return a failure json response
        def error(_sMsg)
            return { :success => false, :error => _sMsg }.to_json;
        end

        # invoke a method
        def reply(_sCmd); method(_sCmd).call; end

        # returns true if class support <_sCmd> method otherwise returns false
        def supports?(_sCmd)
            aInvalid = %w(initialize assure success error reply supports?);
            aInvalid.map! { |sName| sName.to_sym };
            aValid = public_methods(false) - aInvalid;
            return aValid.include?(_sCmd.to_sym);
        end

    end # class ReqHandler

end # module Schema

