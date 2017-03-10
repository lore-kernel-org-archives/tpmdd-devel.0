From: Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: Support for Crypto Agile format in IMA
Date: Fri, 10 Mar 2017 16:47:22 -0500
Message-ID: <1489182442.28954.112.camel@linux.vnet.ibm.com>
References: <D1203BA5BAF1AF4DAC3967497AD1E070B74F64@lhreml502-mbs>
	<1488906121.3216.76.camel@linux.vnet.ibm.com>
	<c3469990-bc82-0fa5-1bfd-2ef1695acaf4@huawei.com>
	<1488921155.21855.5.camel@linux.vnet.ibm.com>
	<3fdfbe53-9d33-03d9-535d-4d3330fdb186@huawei.com>
	<524b8d73-b8f9-8793-f34c-97f7ec491076@linux.vnet.ibm.com>
	<8713b9a2-7eff-f84a-133d-b20169862cfa@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
In-Reply-To: <8713b9a2-7eff-f84a-133d-b20169862cfa-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
	<mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: Roberto Sassu <roberto.sassu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: "linux-ima-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org" <linux-ima-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: tpmdd-devel@lists.sourceforge.net

On Fri, 2017-03-10 at 17:28 +0100, Roberto Sassu wrote:
> On 3/10/2017 4:36 PM, Ken Goldman wrote:
> > It's not a TCG standard, just a way of making sure the unused PCR bank
> > doesn't remain at zero, permitting forged measurements.
> >
> > As for the verifier, I ignore the bank I'm not interested in.  I don't
> > verify the truncated/padded bank.
> 
> Truncated/padded digests are needed, if after kexec different banks
> can be selected.

Right.  In our use case scenario, the initial Linux is Petitboot, a boot
loader, while the kexec'ed kernel image can be a distro or custom image.

Mimi
 
> This issue does not arise if all banks are extended only once,
> during IMA initialization. All digests should be passed to a new
> function defined in the TPM driver.
> 
> Roberto


------------------------------------------------------------------------------
Announcing the Oxford Dictionaries API! The API offers world-renowned
dictionary content that is easy and intuitive to access. Sign up for an
account today to start using our lexical data to power your apps and
projects. Get started today and enter our developer competition.
http://sdm.link/oxford
