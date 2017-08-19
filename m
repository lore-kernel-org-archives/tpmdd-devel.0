From: Seiji Munetoh <seiji.munetoh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Nuvoton NPCT650 I2C TPM issues
Date: Sat, 19 Aug 2017 21:47:28 +0900
Message-ID: <CADX6gZxX-7SCayU7+E0dvr0O16j6+gpcZeF4OoK=dCpcepz14Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=tpmdd-devel>
List-Post: <mailto:tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Help: <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/tpmdd-devel>,
 <mailto:tpmdd-devel-request-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org?subject=subscribe>
Errors-To: tpmdd-devel-bounces-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
To: tpmdd-devel <tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
List-Id: tpmdd-devel@lists.sourceforge.net

Hi,

I'm trying to use Nuvoton NPCT650 I2C TPM with Raspberry Pi.
So far, the tpm_i2c_nuvoton driver (I tested 4.4, 4.9, and 4.12) do
not work with the NPCT650 TPM chip.

It seems the TPM requires some delay between I2C messages like
tpm_i2c_infinion driver do. However the i2c_smbus_* commands
used by the tpm_i2c_nuvoton driver does not support such delay.

The TPM itself seems to be functional since I can communicate
with the TPM by a python script.

regards,
--
Seiji

------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
