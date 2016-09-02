From: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: Re: [tpmdd-devel] [PATCH] Documentation: tpm: Adds the TPM device
 tree node documentation
Date: Fri, 2 Sep 2016 19:00:56 +0300
Message-ID: <20160902160056.GA13795@intel.com>
References: <1472532277-21933-1-git-send-email-nayna@linux.vnet.ibm.com>
 <20160830063631.GA5336@intel.com>
 <20160902145238.GB9636@rob-hp-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-i2c-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160902145238.GB9636@rob-hp-laptop>
Sender: linux-i2c-owner@vger.kernel.org
To: Rob Herring <robh@kernel.org>
Cc: Nayna Jain <nayna@linux.vnet.ibm.com>, tpmdd-devel@lists.sourceforge.net, devicetree@vger.kernel.org, mark.rutland@arm.com, pawel.moll@arm.com, ijc+devicetree@hellion.org.uk, wsa@the-dreams.de, gcwilson@us.ibm.com, linux-i2c@vger.kernel.org, galak@codeaurora.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, Sep 02, 2016 at 09:52:38AM -0500, Rob Herring wrote:
> On Tue, Aug 30, 2016 at 09:36:31AM +0300, Jarkko Sakkinen wrote:
> > On Tue, Aug 30, 2016 at 12:44:37AM -0400, Nayna Jain wrote:
> > > This is documenting device tree binding for
> > > I2C based TPM, similar concept which being used
> > > for virtual TPM on POWER7 and POWER8 systems running PowerVM.
> > > 
> > > Signed-off-by: Nayna Jain <nayna@linux.vnet.ibm.com>
> > > ---
> > >  Documentation/devicetree/bindings/i2c/i2c-tpm.txt | 29 +++++++++++++++++++++++
> > >  1 file changed, 29 insertions(+)
> > >  create mode 100644 Documentation/devicetree/bindings/i2c/i2c-tpm.txt
> > > 
> > > diff --git a/Documentation/devicetree/bindings/i2c/i2c-tpm.txt b/Documentation/devicetree/bindings/i2c/i2c-tpm.txt
> > > new file mode 100644
> > > index 0000000..8fdee14
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/i2c/i2c-tpm.txt
> > > @@ -0,0 +1,29 @@
> > > +Device Tree Bindings for I2C based Trusted Platform Module(TPM)
> > > +---------------------------------------------------------------
> > > +
> > > +This node describes a TPM device connected to Processor on i2c bus.
> > > +
> > > +Required properties:
> > > +
> > > +- compatible : 'manufacturer,model'
> > > +- label : represents device type
> > > +- linux,sml-base : base address of the Event Log. It is a physical address.
> > > +		   sml stands for shared memory log.
> > > +- linux,sml-size : size of the memory allocated for the Event Log.
> > > +
> > > +Optional properties:
> > > +
> > > +- status: indicates whether the device is enabled or disabled. "okay" for
> > > +          enabled and "disabled" for disabled.
> > > +
> > > +Example
> > > +-------
> > > +
> > > +tpm@57 {
> > > +	reg = <0x57>;
> > > +	label = "tpm";
> > > +	compatible = "nuvoton,npct650", "nuvoton,npct601";
> > > +	linux,sml-base = <0x7f 0xfd450000>;
> > > +	linux,sml-size = <0x10000>;
> > > +	status = "okay";
> > > +};
> > 
> > I would rather name the fields event-log-base and event-log-size. They
> > would be much more readable and obvious names.
> > 
> > Also, enabled should be "enabled", not "okay".
> 
> No, okay is correct. But as I mentioned, don't document it here.

We'll stick to sml-base and sml-size because the existing code binds
already to those names.

/Jakrko
