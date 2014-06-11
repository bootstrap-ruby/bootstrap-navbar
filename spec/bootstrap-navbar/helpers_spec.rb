require 'spec_helper'

describe BootstrapNavbar::Helpers do
  describe 'including' do
    context 'when Bootstrap version is set' do
      before do
        BootstrapNavbar.configuration.bootstrap_version = '3.0.2'
      end

      it "doesn't raise an exception" do
        expect do
          Class.new do
            include BootstrapNavbar::Helpers
          end
        end.to_not raise_exception
      end
    end

    context 'when Bootstrap version is not set' do
      before do
        BootstrapNavbar.configuration.unset :bootstrap_version
      end

      context 'when bootstrap-sass gem is not loaded' do
        before do
          # Remove bootstrap-sass from loaded specs
          loaded_specs = Gem.loaded_specs.dup
          loaded_specs.delete('bootstrap-sass')
          allow(Gem).to receive(:loaded_specs).and_return(loaded_specs)
        end

        it 'raises an exception' do
          expect(Gem.loaded_specs.keys).to_not include('bootstrap-sass')
          expect do
            Class.new do
              include BootstrapNavbar::Helpers
            end
          end.to raise_exception('Bootstrap version is not configured.')
        end
      end

      context 'when bootstrap-sass gem is loaded' do
        it 'sniffs the Bootstrap version from bootstrap-sass' do
          expect(Gem.loaded_specs.keys).to include('bootstrap-sass')
          expect do
            Class.new do
              include BootstrapNavbar::Helpers
            end
          end.to_not raise_exception
          expect(BootstrapNavbar.configuration.bootstrap_version).to eq('3.0.2')
        end
      end
    end
  end
end
