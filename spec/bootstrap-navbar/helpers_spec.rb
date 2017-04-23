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

      def remove_gems_from_loaded_specs(*gems)
        loaded_specs = Gem.loaded_specs.dup
        gems.each do |gem|
          loaded_specs.delete(gem)
        end
        allow(Gem).to receive(:loaded_specs).and_return(loaded_specs)
      end

      context 'when neither the bootstrap-sass gem nor the bootstrap gem is not loaded' do
        before do
          remove_gems_from_loaded_specs('bootstrap-sass', 'bootstrap')
        end

        it 'raises an exception' do
          expect do
            Class.new do
              include BootstrapNavbar::Helpers
            end
          end.to raise_exception('Bootstrap version is not configured.')
        end
      end

      context 'when only the bootstrap-sass gem is loaded' do
        before do
          remove_gems_from_loaded_specs('bootstrap')
        end

        it 'sniffs the Bootstrap version from bootstrap-sass' do
          expect do
            Class.new do
              include BootstrapNavbar::Helpers
            end
          end.to_not raise_exception
          expect(BootstrapNavbar.configuration.bootstrap_version).to eq('3.0.2')
        end
      end

      context 'when only the bootstrap gem is loaded' do
        before do
          remove_gems_from_loaded_specs('bootstrap-sass')
        end

        it 'sniffs the Bootstrap version from bootstrap-sass' do
          expect do
            Class.new do
              include BootstrapNavbar::Helpers
            end
          end.to_not raise_exception
          expect(BootstrapNavbar.configuration.bootstrap_version).to eq('4.0.0')
        end
      end
    end
  end
end
