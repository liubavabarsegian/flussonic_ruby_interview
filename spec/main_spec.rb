# frozen_string_literal: true

require '../main'

RSpec.describe Chain do
  describe 'valid?' do
    context 'only years' do
      it 'should return true' do
        periods = Chain.new('16.07.2023', %w[2023 2024 2025])
        expect(periods.valid?).to be_truthy
      end

      it 'should return false' do
        periods = Chain.new('24.04.2023', %w[2023 2025 2026])
        expect(periods.valid?).to be_falsey
      end
    end

    context 'years and months' do
      it 'should return true' do
        periods = Chain.new('31.01.2023', %w[2023M1 2023M2 2023M3])
        expect(periods.valid?).to be_truthy
      end

      it 'should return false' do
        periods = Chain.new('10.01.2023', %w[2023M1 2023M3 2023M4])
        expect(periods.valid?).to be_falsey
      end
    end

    context 'years, months and days' do
      it 'should return true' do
        periods = Chain.new('04.06.1976', %w[1976M6D4 1976M6D5 1976M6D6])
        expect(periods.valid?).to be_truthy
      end

      it 'should return false' do
        periods = Chain.new('02.05.2023', %w[2023M5D2 2023M5D3 2023M5D5])
        expect(periods.valid?).to be_falsey
      end
    end

    context 'mixed' do
      it 'should return true' do
        periods = Chain.new('30.01.2023', %w[2023M1 2023M2 2023M3D30])
        expect(periods.valid?).to be_truthy
      end

      it 'should return false' do
        periods = Chain.new('31.01.2023', %w[2023M1 2023M2 2023M3D30])
        expect(periods.valid?).to be_falsey
      end

      it 'should return true' do
        periods = Chain.new('30.01.2020', %w[2020M1 2020 2021 2022 2023 2024M2 2024M3D30])
        expect(periods.valid?).to be_truthy
      end

      it 'should return false' do
        periods = Chain.new('30.01.2020', %w[2020M1 2020 2021 2022 2023 2024M2 2024M3D29])
        expect(periods.valid?).to be_falsey
      end

      it 'should return true' do
        periods = Chain.new('30.01.2023',
                            %w[2023M1D30 2023M1 2023M2 2023 2024M3 2024M4D30 2024M5])
        expect(periods.valid?).to be_truthy
      end

      it 'should return false' do
        periods = Chain.new('27.01.2023', %w[2023M1 2023M2 2023M3D28])
        expect(periods.valid?).to be_falsey
      end
    end
  end

  describe 'add' do
    context 'add anually' do
      it 'should add 2025' do
        periods = Chain.new('16.07.2023', %w[2023 2024])
        new_period_type = 'annually'
        expect(periods.add(new_period_type)).to eq(%w[2023 2024 2025])
      end

      it 'should add 2025' do
        periods = Chain.new('31.12.2023', %w[2023M12D31 2024M1 2024])
        new_period_type = 'annually'
        expect(periods.add(new_period_type)).to eq(%w[2023M12D31 2024M1 2024 2025])
      end

      context 'add montly' do
        it 'should add 2023M3' do
          periods = Chain.new('30.01.2023', %w[2023M1D30 2023M1 2023M2])
          new_period_type = 'monthly'
          expect(periods.add(new_period_type)).to eq(%w[2023M1D30 2023M1 2023M2 2023M3])
        end
      end

      context 'add daily' do
        it 'should add 2023M3D31' do
          periods = Chain.new('30.01.2023', %w[2023M1D30 2023M1 2023M2 2023M3D30])
          new_period_type = 'daily'
          expect(periods.add(new_period_type)).to eq(%w[2023M1D30 2023M1 2023M2 2023M3D30 2023M3D31])
        end
      end
      it 'should add 2023M4D1' do
        periods = Chain.new('30.01.2023', %w[2023M1D30 2023M1 2023M2 2023M3D31])
        new_period_type = 'daily'
        expect(periods.add(new_period_type)).to eq(%w[2023M1D30 2023M1 2023M2 2023M3D31 2023M4D1])
      end
    end
  end
end
