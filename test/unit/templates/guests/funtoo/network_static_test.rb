require_relative "../../../base"

require "vagrant/util/template_renderer"

describe "templates/guests/funtoo/network_static" do
  let(:template) { "guests/funtoo/network_static" }

  it "renders the template" do
    result = Vagrant::Util::TemplateRenderer.render(template, options: {
      device:  "en0",
      ip:      "1.1.1.1",
      netmask: "255.255.0.0",
    })
    expect(result).to eq <<-EOH.gsub(/^ {6}/, "")
      #VAGRANT-BEGIN
      # The contents below are automatically generated by Vagrant. Do not modify.
      template='interface'
      ipaddr='1.1.1.1/255.255.0.0'
      #VAGRANT-END
    EOH
  end

  it "includes the gateway" do
    result = Vagrant::Util::TemplateRenderer.render(template, options: {
      device:  "en0",
      ip:      "1.1.1.1",
      netmask: "255.255.0.0",
      gateway: "1.2.3.4",
    })
    expect(result).to eq <<-EOH.gsub(/^ {6}/, "")
      #VAGRANT-BEGIN
      # The contents below are automatically generated by Vagrant. Do not modify.
      template='interface'
      ipaddr='1.1.1.1/255.255.0.0'
      gateway='1.2.3.4'
      #VAGRANT-END
    EOH
  end

  it "includes the nameservers" do
    result = Vagrant::Util::TemplateRenderer.render(template, options: {
      device:      "en0",
      ip:          "1.1.1.1",
      netmask:     "255.255.0.0",
      nameservers: "ns1.company.com",
    })
    expect(result).to eq <<-EOH.gsub(/^ {6}/, "")
      #VAGRANT-BEGIN
      # The contents below are automatically generated by Vagrant. Do not modify.
      template='interface'
      ipaddr='1.1.1.1/255.255.0.0'
      nameservers='ns1.company.com'
      #VAGRANT-END
    EOH
  end

  it "includes the domain" do
    result = Vagrant::Util::TemplateRenderer.render(template, options: {
      device:  "en0",
      ip:      "1.1.1.1",
      netmask: "255.255.0.0",
      domain:  "company.com",
    })
    expect(result).to eq <<-EOH.gsub(/^ {6}/, "")
      #VAGRANT-BEGIN
      # The contents below are automatically generated by Vagrant. Do not modify.
      template='interface'
      ipaddr='1.1.1.1/255.255.0.0'
      domain='company.com'
      #VAGRANT-END
    EOH
  end

  it "includes the route" do
    result = Vagrant::Util::TemplateRenderer.render(template, options: {
      device:  "en0",
      ip:      "1.1.1.1",
      netmask: "255.255.0.0",
      route:   "5.6.7.8",
    })
    expect(result).to eq <<-EOH.gsub(/^ {6}/, "")
      #VAGRANT-BEGIN
      # The contents below are automatically generated by Vagrant. Do not modify.
      template='interface'
      ipaddr='1.1.1.1/255.255.0.0'
      route='5.6.7.8'
      #VAGRANT-END
    EOH
  end

  it "includes the gateway6" do
    result = Vagrant::Util::TemplateRenderer.render(template, options: {
      device:   "en0",
      ip:       "1.1.1.1",
      netmask:  "255.255.0.0",
      gateway6: "aaaa:0000",
    })
    expect(result).to eq <<-EOH.gsub(/^ {6}/, "")
      #VAGRANT-BEGIN
      # The contents below are automatically generated by Vagrant. Do not modify.
      template='interface'
      ipaddr='1.1.1.1/255.255.0.0'
      gateway6='aaaa:0000'
      #VAGRANT-END
    EOH
  end

  it "includes the route6" do
    result = Vagrant::Util::TemplateRenderer.render(template, options: {
      device:  "en0",
      ip:      "1.1.1.1",
      netmask: "255.255.0.0",
      route6:  "bbbb:1111",
    })
    expect(result).to eq <<-EOH.gsub(/^ {6}/, "")
      #VAGRANT-BEGIN
      # The contents below are automatically generated by Vagrant. Do not modify.
      template='interface'
      ipaddr='1.1.1.1/255.255.0.0'
      route6='bbbb:1111'
      #VAGRANT-END
    EOH
  end

  it "includes the mtu" do
    result = Vagrant::Util::TemplateRenderer.render(template, options: {
      device:  "en0",
      ip:      "1.1.1.1",
      netmask: "255.255.0.0",
      mtu:     "1",
    })
    expect(result).to eq <<-EOH.gsub(/^ {6}/, "")
      #VAGRANT-BEGIN
      # The contents below are automatically generated by Vagrant. Do not modify.
      template='interface'
      ipaddr='1.1.1.1/255.255.0.0'
      mtu='1'
      #VAGRANT-END
    EOH
  end
end
